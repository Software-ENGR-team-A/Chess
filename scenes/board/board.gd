class_name Board
extends Node2D

const BOARD_SCENE := preload("res://scenes/board/board.tscn")
const AUDIO_BUS := preload("res://scenes/sound_system/default_bus_layout.tres")

@export var squares: BoardSquares
@export var pieces: Node

## Current amount of moves taken. If even, white to play.
var half_moves := 0

## Tracks if the board is the root board. Changes /
var is_primary: bool

var queued_bitmaps: Array
var queued_pieces: Array

# Debug
var debug_timelines := []
var debug_timelines_half_move := half_moves


## Sets all the root information for a board.
## [param floor_map]: Initial floor_map for the board's [member squares]
## [param pieces_array]: Array of [Piece]s to put on the board
func setup(is_primary, floor_map: Array, pieces_array: Array) -> void:
	self.is_primary = is_primary

	if ready:
		load_queued_state(floor_map, pieces_array)
	else:
		queued_bitmaps = floor_map
		queued_pieces = pieces_array


func _ready() -> void:
	if queued_bitmaps.size() > 0 and queued_pieces.size() > 0:
		load_queued_state(queued_bitmaps, queued_pieces)
		queued_bitmaps = []
		queued_pieces = []

	if is_primary:
		MusicManager.play_random_song()


func _input(event) -> void:
	if not is_primary:
		return

	var hovered_square = squares.local_to_map(squares.get_local_mouse_position())

	if pieces.held_piece != null:
		# Fetch world position from cursor in viewport
		var vport = get_viewport()
		var screen_mouse_position = vport.get_mouse_position()  # Get mouse position on screen
		var world_pos = (
			(vport.get_screen_transform() * vport.get_canvas_transform()).affine_inverse()
			* screen_mouse_position
		)

		# Move piece under cursor
		pieces.held_piece.position = round(world_pos)

	else:
		squares.set_highlight(hovered_square)

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if pieces.held_piece == null:
			# Pick up piece
			AudioManager.play_sound(AudioManager.movement.pickup)

			var piece_at_cell = pieces.at(hovered_square)
			if piece_at_cell and piece_at_cell.player == half_moves % 2:
				pieces.held_piece = piece_at_cell
				pieces.held_piece.show_shadow()
				# Bring to front
				pieces.move_child(pieces.held_piece, pieces.get_child_count() - 1)

				# Highlight places where it can be moved
				squares.recolor(pieces.held_piece)

		else:
			# Try to put down piece
			if (
				squares.has_floor_at(hovered_square)
				and Piece.movement_safe_for_king(
					pieces.held_piece.movement_outcome_at(hovered_square)
				)
			):
				# Put down piece
				pieces.held_piece.move_to(hovered_square)
				half_moves += 1

				# Verify checkmate state for opposite player
				var king_to_consider = (
					pieces.white_king if half_moves % 2 == 0 else pieces.black_king
				)
				if is_primary and king_to_consider.in_checkmate():
					AudioManager.play_sound(AudioManager.movement.checkmate, -15)
					print(
						("Black" if king_to_consider == pieces.white_king else "White") + " wins!"
					)

				AudioManager.play_sound(AudioManager.movement.place)

			else:
				# Revert location
				pieces.held_piece.set_board_pos(pieces.held_piece.board_pos)
				AudioManager.play_sound(AudioManager.movement.invalid)

			pieces.held_piece.show_shadow(false)
			pieces.held_piece = null
			squares.recolor(null)


## Turns the data in a supplied [param new_state] into a setup for gameplay by setting board square
## colours and loading [Piece] nodes as needed
func load_queued_state(squares_data, new_pieces) -> void:
	squares.setup(self, squares_data)
	pieces.setup(self, new_pieces)


## Creates and returns a copy of the current [Board]
func branch() -> Board:
	var new_timeline := BOARD_SCENE.instantiate()
	new_timeline.setup(false, squares.floor_data.duplicate(true), pieces.branch_pieces())

	for piece in new_timeline.pieces.get_children():
		new_timeline.pieces.map.set(piece.board_pos, piece)
		if piece is King:
			if not piece.player:
				new_timeline.pieces.black_king = piece
			else:
				new_timeline.pieces.white_king = piece
		piece.board = new_timeline

	return new_timeline


## Makes a recursive search from an origin point.
##[param base]: The starting point to check from
##[param dir]: The offset vector to check each iteration
##[param repeat]: The maximum amount of times to perform the check
func look_in_direction(base: Vector2i, dir: Vector2i, repeat: int) -> Piece:
	var next = base + dir
	if not squares.has_floor_at(next) or repeat <= 0:
		return

	var piece = pieces.at(next)
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
	new_window.position = Vector2i(
		debug_timelines.size() * 20 + 20, debug_timelines.size() * 20 + 20
	)
	get_tree().root.add_child(new_window)
	new_window.add_child(board)
	new_window.show()
	board.get_node("Camera").zoom = Vector2(4, 4)

	debug_timelines.push_back(new_window)
