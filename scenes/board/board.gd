class_name Board
extends Node2D

const PIECE_SCENE := preload("res://scenes/piece/piece.tscn")
const AUDIO_BUS := preload("res://scenes/sound_system/default_bus_layout.tres")

# Load all piece classes to prevent null pointers
const PAWN_SCRIPT := preload("res://scenes/piece/Pawn.gd")
const ROOK_SCRIPT := preload("res://scenes/piece/Rook.gd")
const KNIGHT_SCRIPT := preload("res://scenes/piece/Knight.gd")
const BISHOP_SCRIPT := preload("res://scenes/piece/Bishop.gd")
const QUEEN_SCRIPT := preload("res://scenes/piece/Queen.gd")
const KING_SCRIPT := preload("res://scenes/piece/King.gd")

# Sprite Indices
const TILESET_ID := 0

const WHITE_TILE := Vector2i(0, 3)
const BLACK_TILE := Vector2i(0, 7)
const CYAN_TILE := Vector2i(1, 3)
const DARK_CYAN_TILE := Vector2i(1, 7)
const GREEN_TILE := Vector2i(2, 3)
const DARK_GREEN_TILE := Vector2i(2, 7)
const PURPLE_TILE := Vector2i(3, 3)
const DARK_PURPLE_TILE := Vector2i(3, 7)
const ORANGE_TILE := Vector2i(4, 3)
const DARK_ORANGE_TILE := Vector2i(4, 7)
const RED_TILE := Vector2i(5, 3)
const DARK_RED_TILE := Vector2i(5, 7)

@export var square_bitmaps := []
@export var start_pieces := []
@export var square_map: TileMapLayer
@export var pieces: Node
@export var box_cursor: BoxCursor

var default_state := {
	squares =  # The starting board state
	[
		0b0000000000000000,
		0b0000000000000000,
		0b0000000000000000,
		0b0000000000000000,
		0b0000111111110000,
		0b0000111111110000,
		0b0000111111110000,
		0b0000111111110000,
		0b0000111111110000,
		0b0000111111110000,
		0b0000111111110000,
		0b0000111111110000,
		0b0000000000000000,
		0b0000000000000000,
		0b0000000000000000,
		0b0000000000000000
	],
	pieces =
	[
		# White Front Row
		{"script": PAWN_SCRIPT, "pos": Vector2i(-4, -3), "player": 0},
		{"script": PAWN_SCRIPT, "pos": Vector2i(-3, -3), "player": 0},
		{"script": PAWN_SCRIPT, "pos": Vector2i(-2, -3), "player": 0},
		{"script": PAWN_SCRIPT, "pos": Vector2i(-1, -3), "player": 0},
		{"script": PAWN_SCRIPT, "pos": Vector2i(0, -3), "player": 0},
		{"script": PAWN_SCRIPT, "pos": Vector2i(1, -3), "player": 0},
		{"script": PAWN_SCRIPT, "pos": Vector2i(2, -3), "player": 0},
		{"script": PAWN_SCRIPT, "pos": Vector2i(3, -3), "player": 0},
		# White Back Row
		{"script": ROOK_SCRIPT, "pos": Vector2i(-4, -4), "player": 0},
		{"script": KNIGHT_SCRIPT, "pos": Vector2i(-3, -4), "player": 0},
		{"script": BISHOP_SCRIPT, "pos": Vector2i(-2, -4), "player": 0},
		{"script": KING_SCRIPT, "pos": Vector2i(-1, -4), "player": 0},
		{"script": QUEEN_SCRIPT, "pos": Vector2i(0, -4), "player": 0},
		{"script": BISHOP_SCRIPT, "pos": Vector2i(1, -4), "player": 0},
		{"script": KNIGHT_SCRIPT, "pos": Vector2i(2, -4), "player": 0},
		{"script": ROOK_SCRIPT, "pos": Vector2i(3, -4), "player": 0},
		# Black Front Row
		{"script": PAWN_SCRIPT, "pos": Vector2i(-4, 2), "player": 1},
		{"script": PAWN_SCRIPT, "pos": Vector2i(-3, 2), "player": 1},
		{"script": PAWN_SCRIPT, "pos": Vector2i(-2, 2), "player": 1},
		{"script": PAWN_SCRIPT, "pos": Vector2i(-1, 2), "player": 1},
		{"script": PAWN_SCRIPT, "pos": Vector2i(0, 2), "player": 1},
		{"script": PAWN_SCRIPT, "pos": Vector2i(1, 2), "player": 1},
		{"script": PAWN_SCRIPT, "pos": Vector2i(2, 2), "player": 1},
		{"script": PAWN_SCRIPT, "pos": Vector2i(3, 2), "player": 1},
		# Black Back Row
		{"script": ROOK_SCRIPT, "pos": Vector2i(-4, 3), "player": 1},
		{"script": KNIGHT_SCRIPT, "pos": Vector2i(-3, 3), "player": 1},
		{"script": BISHOP_SCRIPT, "pos": Vector2i(-2, 3), "player": 1},
		{"script": KING_SCRIPT, "pos": Vector2i(-1, 3), "player": 1},
		{"script": QUEEN_SCRIPT, "pos": Vector2i(0, 3), "player": 1},
		{"script": BISHOP_SCRIPT, "pos": Vector2i(1, 3), "player": 1},
		{"script": KNIGHT_SCRIPT, "pos": Vector2i(2, 3), "player": 1},
		{"script": ROOK_SCRIPT, "pos": Vector2i(3, 3), "player": 1}
	]
}

# Nodes
var held_piece: Node
var white_king: King
var black_king: King

# State
var half_moves := 0
var last_tile_highlighted: Vector2i
var piece_map: Dictionary = {}

# Debug
var debug_timelines := []
var debug_timelines_half_move := half_moves


func _ready() -> void:
	if is_og():
		load_board_state(default_state)
		MusicManager.play_random_song()


func _process(_delta) -> void:
	pass


func _input(event) -> void:
	var hovered_square = square_map.local_to_map(square_map.get_local_mouse_position())

	box_cursor.lerp_to_board_pos(hovered_square)

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
		# Reset previous tile
		if hovered_square != last_tile_highlighted and last_tile_highlighted != null:
			if square_map.get_cell_atlas_coords(last_tile_highlighted) == CYAN_TILE:
				square_map.set_cell(last_tile_highlighted, TILESET_ID, WHITE_TILE)
			elif square_map.get_cell_atlas_coords(last_tile_highlighted) == DARK_CYAN_TILE:
				square_map.set_cell(last_tile_highlighted, TILESET_ID, BLACK_TILE)

		# Set current tile
		if square_map.get_cell_atlas_coords(hovered_square) == WHITE_TILE:
			square_map.set_cell(hovered_square, TILESET_ID, CYAN_TILE)
			last_tile_highlighted = hovered_square
		elif square_map.get_cell_atlas_coords(hovered_square) == BLACK_TILE:
			square_map.set_cell(hovered_square, TILESET_ID, DARK_CYAN_TILE)
			last_tile_highlighted = hovered_square

	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if held_piece == null:
			# Pick up piece
			box_cursor.set_board_pos(hovered_square)
			AudioManager.play_sound(AudioManager.movement.pickup)

			var piece_at_cell = get_piece_at(hovered_square)
			if piece_at_cell and piece_at_cell.player == half_moves % 2:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				held_piece = piece_at_cell
				held_piece.show_shadow()
				# Bring to front
				pieces.move_child(held_piece, pieces.get_child_count() - 1)

				# Highlight places where it can be moved
				color_board_squares(held_piece)

		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			# Try to put down piece
			if (
				has_floor_at(hovered_square)
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
			color_board_squares(null)


func _notification(event):
	if event == NOTIFICATION_WM_CLOSE_REQUEST:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


## Returns if the board is the actual "main" game instance being played. Used to distinguish from
## "fake" boards used for determining the outcomes of future moves, for instance.
func is_og() -> bool:
	if not is_inside_tree():
		return false
	return get_tree().get("root") == get_parent()


## Returns [code]true[/true] if the [param pos] is a valid square that pieces can be on,
## as opposed to a hole.
func has_floor_at(pos: Vector2i) -> bool:
	if pos.x < -8 or pos.x > 8:
		return false
	return get_bit(square_bitmaps[pos.y - 8], 16 - pos.x - 8 - 1)


## Creates or destroys a square tile on the board. Returns if a change was made or not
## [param pos]: The tile to change
## [param on]: Whether to enable or disable the file
func set_floor_at(pos: Vector2i, on: bool) -> bool:
	if pos.clampi(-8, 7) != pos:
		return false

	var has_floor := has_floor_at(pos)
	var to_add := 1 << (16 - pos.x - 8 - 1)

	if has_floor and not on:
		to_add = -1 * to_add
	elif not (has_floor and on):
		return false

	square_bitmaps[pos.y - 8] += to_add
	return true


## Returns the [Piece] in the board's [member piece_map] at [param pos], or
## [code]null[/code] if absent.
func get_piece_at(pos: Vector2i) -> Piece:
	return piece_map.get(pos)


## Re-calculates all the tiles in the [member squares] TileMapLayer. If supplied a
## [param selected_piece], the floor will indicate valid movement options for that piece.
func color_board_squares(selected_piece: Piece) -> void:
	# Load Squares
	for col in range(0, 16):
		for row in range(0, 16):
			var map_cell = Vector2i(row - 8, col - 8)
			if has_floor_at(map_cell):
				var tiles = calculate_square_tile_at(map_cell, selected_piece)
				square_map.set_cell(
					map_cell, TILESET_ID, tiles.light if (row + col) % 2 == 0 else tiles.dark
				)
			elif square_map.get_cell_tile_data(map_cell):
				square_map.erase_cell(map_cell)


## Returns what tiles should be used for a given [param map_cell], indicating valid movement options
## for an optional [param selected_piece]. Output format is a dictionary of the form
## [code]{"light": LIGHT_TILE, "dark": DARK_TILE}[/code]
func calculate_square_tile_at(map_cell: Vector2i, selected_piece: Piece) -> Dictionary:
	var piece_at_cell = get_piece_at(map_cell)
	if piece_at_cell is King:
		if piece_at_cell.in_check():
			return {"light": ORANGE_TILE, "dark": DARK_ORANGE_TILE}

	if selected_piece:
		if selected_piece.board_pos == map_cell:
			return {"light": CYAN_TILE, "dark": DARK_CYAN_TILE}

		var outcome = selected_piece.movement_outcome_at(map_cell)

		if outcome == Piece.MovementOutcome.AVAILABLE:
			return {"light": GREEN_TILE, "dark": DARK_GREEN_TILE}

		if outcome == Piece.MovementOutcome.CAPTURE:
			return {"light": RED_TILE, "dark": DARK_RED_TILE}

	return {"light": WHITE_TILE, "dark": BLACK_TILE}


## Turns the data in a supplied [param new_state] into a setup for gameplay by setting board square
## colours and loading [Piece] nodes as needed
func load_board_state(new_state) -> void:
	square_bitmaps = new_state.squares
	start_pieces = new_state.pieces

	# Reset Board
	square_map.clear()
	for child in pieces.get_children():
		child.queue_free()

	color_board_squares(null)

	# Load Pieces
	for piece_data in start_pieces:
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
	var new_timeline: Board = duplicate(0b0100)

	# Fix vars
	new_timeline.square_bitmaps = square_bitmaps.duplicate(true)
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
	if not has_floor_at(next) or repeat <= 0:
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


## General utility method. Gets the bit in the [param pos] position in a [param bitfield]
static func get_bit(bitfield: int, pos: int) -> int:
	return (bitfield >> pos) & 1
