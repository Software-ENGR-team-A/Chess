class_name Board
extends Node2D

const BOARD_SCENE := preload("res://scenes/board/board.tscn")
const PIECE_SCENE := preload("res://scenes/piece/piece.tscn")
const AUDIO_BUS := preload("res://scenes/sound_system/default_bus_layout.tres")

@export var squares: BoardSquares
@export var pieces: Node
var start_pieces := []

var queued_bitmaps: Array
var queued_pieces: Array

# Nodes
var held_piece: Node
var white_king: King
var black_king: King

# State
var half_moves := 0
var piece_map: Dictionary = {}

# Debug
var debug_timelines := []
var debug_timelines_half_move := half_moves


func setup(bitmaps, pieces_data) -> void:
	queued_bitmaps = bitmaps
	queued_pieces = pieces_data


func _ready() -> void:
	if is_og():
		load_queued_state(queued_bitmaps, queued_pieces)
		queued_bitmaps = []
		queued_pieces = []

		MusicManager.play_random_song()


func _process(_delta) -> void:
	pass


func _input(event) -> void:
	var hovered_square = squares.local_to_map(squares.get_local_mouse_position())

	if held_piece != null:
		# Fetch world position from cursor in viewport
		var vport = get_viewport()
		var screen_mouse_position = vport.get_mouse_position()  # Get mouse position on screen
		var world_pos = (
			(vport.get_screen_transform() * vport.get_canvas_transform()).affine_inverse()
			* screen_mouse_position
		)

		# Move piece under cursor
		held_piece.position = round(world_pos)

	else:
		squares.set_highlight(hovered_square)

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if held_piece == null:
			# Pick up piece
			AudioManager.play_sound(AudioManager.movement.pickup)

			var piece_at_cell = get_piece_at(hovered_square)
			if piece_at_cell and piece_at_cell.player == half_moves % 2:
				held_piece = piece_at_cell
				held_piece.show_shadow()
				# Bring to front
				pieces.move_child(held_piece, pieces.get_child_count() - 1)

				# Highlight places where it can be moved
				squares.recolor(held_piece, self)

		else:
			# Try to put down piece
			if (
				squares.has_floor_at(hovered_square)
				and Piece.movement_safe_for_king(held_piece.movement_outcome_at(hovered_square))
			):
				# Put down piece
				held_piece.move_to(hovered_square)
				half_moves += 1

				# Verify checkmate state for opposite player
				var king_to_consider = white_king if half_moves % 2 == 0 else black_king
				if is_og() and in_checkmate(king_to_consider):
					AudioManager.play_sound(AudioManager.movement.checkmate, -15)
					print(("Black" if king_to_consider == white_king else "White") + " wins!")

				AudioManager.play_sound(AudioManager.movement.place)

			else:
				# Revert location
				held_piece.set_board_pos(held_piece.board_pos)
				AudioManager.play_sound(AudioManager.movement.invalid)

			held_piece.show_shadow(false)
			held_piece = null
			squares.recolor(null, self)


## Returns if the board is the actual "main" game instance being played. Used to distinguish from
## "fake" boards used for determining the outcomes of future moves, for instance.
func is_og() -> bool:
	if not is_inside_tree():
		return false
	return get_tree().get("root") == get_parent()


## Returns the [Piece] in the board's [member piece_map] at [param pos], or
## [code]null[/code] if absent.
func get_piece_at(pos: Vector2i) -> Piece:
	return piece_map.get(pos)


## Turns the data in a supplied [param new_state] into a setup for gameplay by setting board square
## colours and loading [Piece] nodes as needed
func load_queued_state(squares_data, new_pieces) -> void:
	squares.floor_data = squares_data

	# Reset Board
	squares.recolor(null, self)
	for child in pieces.get_children():
		child.queue_free()

	# Load Pieces
	for piece_data in new_pieces:
		# Iterate through the board, creating instances of each piece
		var piece = spawn_piece(piece_data.script, piece_data.pos, piece_data.player)
		if piece is King:
			if not piece_data.player:
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


## Creates and returns a copy of the current [Board]
func branch() -> Board:
	var new_timeline := BOARD_SCENE.instantiate()
	# TODO fix []
	new_timeline.setup(squares.floor_data, [])

	# Fix vars
	new_timeline.squares.floor_data = squares.floor_data.duplicate(true)
	new_timeline.start_pieces = start_pieces

	for piece in new_timeline.pieces.get_children():
		new_timeline.piece_map.set(piece.board_pos, piece)
		if piece is King:
			if not piece.player:
				new_timeline.black_king = piece
			else:
				new_timeline.white_king = piece
		piece.board = new_timeline

	return new_timeline


## Creates a scene instance of the piece and places it in the pieces array
##[param piece_script]: The proloaded script for the piece
##[param pos]: The Vector2i for the board location
##[param player]: The player that controls the piece
func spawn_piece(piece_script: Script, pos: Vector2i, player: int) -> Piece:
	var new_piece = PIECE_SCENE.instantiate()
	new_piece.set_script(piece_script)
	new_piece.setup(self, pos, player)
	piece_map[pos] = new_piece
	pieces.add_child(new_piece)
	new_piece.name = ("White" if player else "Black") + piece_script.get_global_name()
	return new_piece


## Returns if the supplied [param king] is in checkmate based on the current board state.
func in_checkmate(king: King) -> bool:
	if king.in_check():
		# Check every possible move
		for enemy_piece: Piece in pieces.get_children():
			if enemy_piece.player != king.player:
				continue

			if enemy_piece.has_valid_moves():
				return false

		return true
	return false


## Makes a recursive search from an origin point.
##[param base]: The starting point to check from
##[param dir]: The offset vector to check each iteration
##[param repeat]: The maximum amount of times to perform the check
func look_in_direction(base: Vector2i, dir: Vector2i, repeat: int) -> Piece:
	var next = base + dir
	if not squares.has_floor_at(next) or repeat <= 0:
		return

	var piece = get_piece_at(next)
	if piece:
		return piece

	return look_in_direction(next, dir, repeat - 1)


## Creates a window to show the supplied [param board]. When [member half_moves] changes,
## all previous windows are deleted to reduce clutter.
func show_debug_timeline(board: Board) -> void:
	if half_moves != debug_timelines_half_move:
		for window in debug_timelines:
			window.visible = false
			window.queue_free()
		debug_timelines.clear()
		debug_timelines_half_move = half_moves

	var new_window = Window.new()
	new_window.size = Vector2(600, 600)  # Set desired window size
	var screen_size = DisplayServer.screen_get_size()
	new_window.position = Vector2i(
		# randi_range(0, int(screen_size.x) - 600), randi_range(0, int(screen_size.y) - 600)
		debug_timelines.size() * 20 + 20,
		debug_timelines.size() * 20 + 20
	)
	get_tree().root.add_child(new_window)
	new_window.add_child(board)
	new_window.show()
	board.get_node("Camera").zoom = Vector2(4, 4)

	debug_timelines.push_back(new_window)
