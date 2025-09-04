extends Node2D

var piece_scene := preload("res://scenes/piece/piece.tscn");

@export var state := {}

var default_state := {
	squares = [
		0b0000000000000000,
		0b0000000000000000,
		0b0000000000000000,
		0b0000000000000000,
		0b0000111111110000,
		0b0000111111110000,
		0b0000111111110000,
		0b0000111001110000,
		0b0000111001110000,
		0b0000111111110000,
		0b0000111111110000,
		0b0000111111110000,
		0b0000000000000000,
		0b0000000000000000,
		0b0000000000000000,
		0b0000000000000000
	],
	pieces = [
		# White Front Row
		{
			x = -4, y = -3,
			player = 0, spriteIndex = 0,
		},
		{
			x = -3, y = -3,
			player = 0, spriteIndex = 0,
		},
		{
			x = -2, y = -3,
			player = 0, spriteIndex = 0,
		},
		{
			x = -1, y = -3,
			player = 0, spriteIndex = 0,
		},
		{
			x = 0, y = -3,
			player = 0, spriteIndex = 0,
		},
		{
			x = 1, y = -3,
			player = 0, spriteIndex = 0,
		},
		{
			x = 2, y = -3,
			player = 0, spriteIndex = 0,
		},
		{
			x = 3, y = -3,
			player = 0, spriteIndex = 0,
		},
		# White Back Row
		{
			x = -4, y = -4,
			player = 0, spriteIndex = 3,
		},
		{
			x = -3, y = -4,
			player = 0, spriteIndex = 1,
		},
		{
			x = -2, y = -4,
			player = 0, spriteIndex = 2,
		},
		{
			x = -1, y = -4,
			player = 0, spriteIndex = 4,
		},
		{
			x = 0, y = -4,
			player = 0, spriteIndex = 5,
		},
		{
			x = 1, y = -4,
			player = 0, spriteIndex = 2,
		},
		{
			x = 2, y = -4,
			player = 0, spriteIndex = 1,
		},
		{
			x = 3, y = -4,
			player = 0, spriteIndex = 3,
		},
			# Black Front Row
		{
			x = -4, y = 2,
			player = 1, spriteIndex = 0,
		},
		{
			x = -3, y = 2,
			player = 1, spriteIndex = 0,
		},
		{
			x = -2, y = 2,
			player = 1, spriteIndex = 0,
		},
		{
			x = -1, y = 2,
			player = 1, spriteIndex = 0,
		},
		{
			x = 0, y = 2,
			player = 1, spriteIndex = 0,
		},
		{
			x = 1, y = 2,
			player = 1, spriteIndex = 0,
		},
		{
			x = 2, y = 2,
			player = 1, spriteIndex = 0,
		},
		{
			x = 3, y = 2,
			player = 1, spriteIndex = 0,
		},
		# White Back Row
		{
			x = -4, y = 3,
			player = 1, spriteIndex = 3,
		},
		{
			x = -3, y = 3,
			player = 1, spriteIndex = 1,
		},
		{
			x = -2, y = 3,
			player = 1, spriteIndex = 2,
		},
		{
			x = -1, y = 3,
			player = 1, spriteIndex = 4,
		},
		{
			x = 0, y = 3,
			player = 1, spriteIndex = 5,
		},
		{
			x = 1, y = 3,
			player = 1, spriteIndex = 2,
		},
		{
			x = 2, y = 3,
			player = 1, spriteIndex = 1,
		},
		{
			x = 3, y = 3,
			player = 1, spriteIndex = 3,
		},
	]
}

# Nodes
var square_map: TileMapLayer
var pieces: Node
var held_piece: Node
var piece_map: Dictionary = {}

# State
var last_tile_highlighted: Vector2i

# Sprite Indices
const tileset_id := 0
const white_tile := Vector2i(0, 3)
const black_tile := Vector2i(0, 7)
const white_tile_highlighted := Vector2i(1, 3)
const black_tile_highlighted := Vector2i(1, 7)
const green_tile := Vector2i(2, 3)
const dark_green_tile := Vector2i(2, 7)

func _ready():
	square_map = $Squares
	pieces = $Pieces
	loadBoardState(default_state)


func _process(_delta):
	pass


func _input(event):
	var hovered_square = square_map.local_to_map(square_map.get_local_mouse_position())

	if held_piece != null:
		# Fetch world position from cursor in viewport
		var vport = get_viewport()
		var screen_mouse_position = vport.get_mouse_position() # Get the mouse position on the screen
		var world_pos = (vport.get_screen_transform() * vport.get_canvas_transform()).affine_inverse() * screen_mouse_position
		
		# Move piece under cursor
		held_piece.position = round(world_pos)

	else:
		# Reset previous tile
		if hovered_square != last_tile_highlighted and last_tile_highlighted != null:
			if square_map.get_cell_atlas_coords(last_tile_highlighted) == white_tile_highlighted:
				square_map.set_cell(last_tile_highlighted, tileset_id, white_tile)
			elif square_map.get_cell_atlas_coords(last_tile_highlighted) == black_tile_highlighted:
				square_map.set_cell(last_tile_highlighted, tileset_id, black_tile)
			
		# Set current tile
		if square_map.get_cell_atlas_coords(hovered_square) == white_tile:
			square_map.set_cell(hovered_square, tileset_id, white_tile_highlighted)
			last_tile_highlighted = hovered_square
		elif square_map.get_cell_atlas_coords(hovered_square) == black_tile:
			square_map.set_cell(hovered_square, tileset_id, black_tile_highlighted)
			last_tile_highlighted = hovered_square

	
	if event is InputEventMouseButton and event.pressed:
		
		if held_piece == null:
			# Pick up piece
			var piece_at_cell = piece_map.get(hovered_square)
			if piece_at_cell:
				held_piece = piece_at_cell
				
				# Bring to front
				pieces.move_child(held_piece, pieces.get_child_count() - 1)

				# Highlight places where it can be moved
				loadBoardSquares(held_piece)

		else:
			if checkFloor(hovered_square):
				# Put down piece
				movePiece(held_piece, hovered_square)
			else:
				# Revert location
				movePiece(held_piece, held_piece.square_pos)

			held_piece = null
			loadBoardSquares(null)


func loadBoardSquares(selected_piece: Piece):
	# Load Squares
	for row in range(0, 16):
		for col in range(0, 16):
			var map_cell = Vector2i(col - 8, row - 8)
			if checkFloor(map_cell):
				if selected_piece and selected_piece.square_pos == map_cell:
					square_map.set_cell(map_cell, 0, white_tile_highlighted if (row + col) % 2 == 0 else black_tile_highlighted)
				elif selected_piece and selected_piece.canMoveTo(map_cell):
					square_map.set_cell(map_cell, 0, green_tile if (row + col) % 2 == 0 else dark_green_tile)
				else:
					square_map.set_cell(map_cell, 0, white_tile if (row + col) % 2 == 0 else black_tile)


func loadBoardState(new_state):
	state = new_state
	
	# Reset Board
	square_map.clear()
	for child in pieces.get_children():
		child.queue_free()

	loadBoardSquares(null)
	
	# Load Pieces
	for piece in state.pieces:
		var instance := piece_scene.instantiate()
		instance.loadPieceData(piece)
		piece_map[Vector2i(piece.x, piece.y)] = instance
		pieces.add_child(instance)


func movePiece(piece: Node, pos: Vector2i):
	# Pick up original piece
	piece_map.set(piece.square_pos, null)

	# "Capture" as necessary (literally just delete it)
	var replaced_piece = piece_map.get(pos)
	if replaced_piece:
		replaced_piece.queue_free()

	# Move piece
	piece.setSquarePos(pos)
	piece_map[pos] = piece


func checkFloor(pos: Vector2i):
	return getBit(state.squares[pos.x - 8], 16 - pos.y - 8 - 1)


func getBit(bitfield: int, pos: int) -> int:
	return (bitfield >> pos) & 1
