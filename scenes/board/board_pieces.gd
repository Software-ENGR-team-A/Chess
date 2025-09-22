class_name BoardPieces
extends Node2D

const PIECE_SCENE := preload("res://scenes/piece/piece.tscn")

# Constants for held piece tilt effect
const ROT_MAX_OMEGA := 90.0
const ROT_GAIN := 0.01
const ROT_DAMPING := 15.0

## The [Board] the squares are associated with
var board: Board

## A map with keys of Vector2i and values of Piece, describing the current location of pieces
var map: Dictionary = {}

## The current piece being manipulated
var held_piece: Piece

# Smoothed-out velocity of the mouse cursor, for held piece tilt
var rot_smooth_vx := 0.0

var rot := 0.0

## Player 0's king
var white_king: King

## Player 1's king
var black_king: King


func setup(board: Board, pieces: Array) -> void:
	self.board = board
	white_king = null
	black_king = null
	for child in get_children():
		child.queue_free()

	# Load Pieces
	for piece in pieces:
		add(piece)
		if piece is King:
			if not piece.player:
				if white_king:
					push_error("Multiple white kings defined")
				white_king = piece
			else:
				if black_king:
					push_error("Multiple black kings defined")
				black_king = piece

	if not white_king:
		push_error("No white king defined")

	if not black_king:
		push_error("No black king defined")


func _process(delta: float) -> void:
	if not held_piece:
		return

	var vx := Input.get_last_mouse_velocity().x
	var alpha := 1.0 - exp(-5.0 * delta)
	rot_smooth_vx = lerp(rot_smooth_vx, vx, alpha)

	rot += ROT_GAIN * rot_smooth_vx
	rot *= exp(-ROT_DAMPING * delta)
	rot = clamp(rot, -ROT_MAX_OMEGA, ROT_MAX_OMEGA) * delta

	held_piece.shadow_rot.rotation = rot
	held_piece.sprite_rot.rotation = rot

## Returns an array of copies of all its Pieces
func branch_pieces() -> Array:
	var output = []
	for piece in get_children():
		output.push_back(piece.branch())
	return output


## Adds a piece, loads it into the map, and sets its board.
func add(new_piece: Piece) -> void:
	map[new_piece.board_pos] = new_piece
	new_piece.board = board
	add_child(new_piece)


## Returns the [Piece] in the board's [member map] at [param pos], or
## [code]null[/code] if absent.
func at(pos: Vector2i) -> Piece:
	return map.get(pos)


## Creates a scene instance of the piece and places it in the pieces array
##[param piece_script]: The proloaded script for the piece
##[param pos]: The Vector2i for the board location
##[param player]: The player that controls the piece
static func spawn_piece(piece_script: Script, pos: Vector2i, player: int) -> Piece:
	var new_piece = PIECE_SCENE.instantiate()
	new_piece.set_script(piece_script)
	new_piece.setup(null, pos, player)
	new_piece.name = (
		("Black" if player else "White") + piece_script.get_global_name() + " " + str(pos)
	)
	return new_piece


## Prepares held [param piece], if any. Resets information from pevious held piece
func pick_up(piece: Piece) -> void:
	# Reset rotation of last held piece
	if held_piece:
		held_piece.sprite_rot.rotation = 0
		held_piece.shadow_rot.rotation = 0
		held_piece.picked_up(false)

	# Highlight places where it can be moved
	board.squares.recolor(piece)

	held_piece = piece

	if piece:
		if piece.board != board:
			return

		piece.picked_up()
		AudioManager.play_sound(AudioManager.movement.pickup)
		
		# Bring to front
		board.pieces.move_child(piece, get_child_count() - 1)


## Returns an array of [Piece] based on an array of dictionaries in the format:
## [code]{ script: Script extends Piece, pos: Vector2i, player: bool }[/code]
static func generate_pieces_from_data(pieces_data: Array) -> Array:
	var output = []
	for piece_data in pieces_data:
		var piece = spawn_piece(piece_data.script, piece_data.pos, piece_data.player)
		output.push_back(piece)
	return output
