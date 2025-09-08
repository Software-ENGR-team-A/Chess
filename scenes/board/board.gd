class_name Board
extends Node2D

const PIECE_SCENE := preload("res://scenes/piece/piece.tscn")
const AUDIO_BUS := preload("res://assets/Audio/default_bus_layout.tres")

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

const DEFAULT_STATE := {
	squares =
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

var start_state := {}

# Nodes
var square_map: TileMapLayer
var pieces: Node
var held_piece: Node
var piece_map: Dictionary = {}

# State
var last_tile_highlighted: Vector2i
var half_moves = 0


## Creates a scene instance of the piece and places it in the pieces array
##[param piece_script]: The proloaded script for the piece
##[param pos]: The Vector2i for the board location
##[param player]: The player that controls the piece
func spawn_piece(piece_script: Script, pos: Vector2i, player: int) -> void:
	var new_piece = PIECE_SCENE.instantiate()
	new_piece.set_script(piece_script)
	new_piece.setup(self, pos, player)
	piece_map[pos] = new_piece
	pieces.add_child(new_piece)


func _ready() -> void:
	square_map = $Squares
	pieces = $Pieces
	load_board_state(DEFAULT_STATE)
	MusicManager.play_random_song()


func _process(_delta) -> void:
	pass


func _input(event) -> void:
	var hovered_square = square_map.local_to_map(square_map.get_local_mouse_position())

	if held_piece != null:
		# Fetch world position from cursor in viewport
		var vport = get_viewport()
		var screen_mouse_position = vport.get_mouse_position()  # Get the mouse position on the screen
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
			AudioManager.play_sound(AudioManager.movement.pickup)

			var piece_at_cell = get_piece_at(hovered_square)
			if piece_at_cell and piece_at_cell.player == half_moves % 2:
				held_piece = piece_at_cell

				# Bring to front
				pieces.move_child(held_piece, pieces.get_child_count() - 1)

				# Highlight places where it can be moved
				load_board_square(held_piece)

		else:
			# Try to put down piece
			if has_floor_at(hovered_square) and held_piece.can_move_to(hovered_square):
				# Put down piece
				move_piece_to(held_piece, hovered_square)
				half_moves += 1
				AudioManager.play_sound(AudioManager.movement.place)

			else:
				# Revert location
				move_piece_to(held_piece, held_piece.board_pos)
				AudioManager.play_sound(AudioManager.movement.invalid)

			held_piece = null
			load_board_square(null)


func load_board_square(selected_piece: Piece) -> void:
	# Load Squares
	for row in range(0, 16):
		for col in range(0, 16):
			var map_cell = Vector2i(col - 8, row - 8)
			if has_floor_at(map_cell):
				var tiles = get_square_tile_at(map_cell, selected_piece)
				square_map.set_cell(
					map_cell, TILESET_ID, tiles.light if (row + col) % 2 == 0 else tiles.dark
				)


func get_square_tile_at(map_cell: Vector2i, selected_piece: Piece) -> Dictionary:
	if selected_piece:
		if selected_piece.board_pos == map_cell:
			return {"light": CYAN_TILE, "dark": DARK_CYAN_TILE}

		var outcome = selected_piece.can_move_to(map_cell)

		if outcome == Piece.MovementOutcome.AVAILABLE:
			return {"light": GREEN_TILE, "dark": DARK_GREEN_TILE}

		if outcome == Piece.MovementOutcome.CAPTURE:
			return {"light": RED_TILE, "dark": DARK_RED_TILE}

	return {"light": WHITE_TILE, "dark": BLACK_TILE}


func load_board_state(new_state) -> void:
	start_state = new_state

	# Reset Board
	square_map.clear()
	for child in pieces.get_children():
		child.queue_free()

	load_board_square(null)

	# Load Pieces
	for piece_data in start_state.pieces:
		# Iterate through the board, creating instances of each piece
		spawn_piece(piece_data.script, piece_data.pos, piece_data.player)


func move_piece_to(piece: Node, pos: Vector2i) -> void:
	# Pick up original piece
	piece_map.set(piece.board_pos, null)

	# Capture
	var replaced_piece = get_piece_at(pos)
	if replaced_piece:
		replaced_piece.capture()

	# Perform extra actions
	piece.movement_actions(pos)

	# Move piece
	piece.previous_position = piece.board_pos
	piece.set_board_pos(pos)
	piece.last_moved_half_move = half_moves
	piece_map[pos] = piece


func look_in_direction(base: Vector2i, dir: Vector2i, repeat: int) -> Piece:
	var next = base + dir
	if not has_floor_at(next) or repeat <= 0:
		return

	var piece = get_piece_at(next)
	if piece:
		return piece

	return look_in_direction(next, dir, repeat - 1)


func has_floor_at(pos: Vector2i) -> bool:
	return get_bit(start_state.squares[pos.x - 8], 16 - pos.y - 8 - 1)


func get_piece_at(pos: Vector2i) -> Piece:
	return piece_map.get(pos)


func get_bit(bitfield: int, pos: int) -> int:
	return (bitfield >> pos) & 1
