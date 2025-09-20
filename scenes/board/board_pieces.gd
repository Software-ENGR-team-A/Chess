class_name BoardPieces
extends Node2D

const PIECE_SCENE := preload("res://scenes/piece/piece.tscn")

## The [Board] the squares are associated with
var board: Board

## A map with keys of Vector2i and values of Piece, describing the current location of pieces
var map: Dictionary = {}

## The current piece being manipulated
var held_piece: Piece

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
	new_piece.name = ("Black" if player else "White") + piece_script.get_global_name() + " "+ str(pos)
	return new_piece


## Returns an array of [Piece] based on an array of dictionaries in the format:
## [code]{ script: Script extends Piece, pos: Vector2i, player: bool }[/code]
static func generate_pieces_from_data(pieces_data: Array) -> Array:
	var output = []
	for piece_data in pieces_data:
		var piece = spawn_piece(piece_data.script, piece_data.pos, piece_data.player)
		output.push_back(piece)
	return output
