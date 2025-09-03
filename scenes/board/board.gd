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
var square_map
var pieces
var held_piece_node

# State
var last_tile_highlighted
var held_piece

# Sprite Indices
const tileset_id := 0
const white_tile := Vector2i(0, 3)
const black_tile := Vector2i(0, 7)
const white_tile_highlighted := Vector2i(1, 3)
const black_tile_highlighted := Vector2i(1, 7)

func _ready():
	square_map = $Squares
	pieces = $Pieces
	held_piece_node = $HeldPiece
	loadBoardState(default_state)


func _process(_delta):
	var vport = get_viewport()
	var screen_mouse_position = vport.get_mouse_position() # Get the mouse position on the screen
	var world_pos = (vport.get_screen_transform() * vport.get_canvas_transform()).affine_inverse() * screen_mouse_position
	var hovered_square = square_map.local_to_map(square_map.get_local_mouse_position())
	
	if held_piece != null:
		# Move piece under cursor
		held_piece_node.position = round(world_pos)
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


func _input(event):
	#var hovered_square = square_map.local_to_map(square_map.get_local_mouse_position())
	
	if event is InputEventMouseButton and event.pressed:
		
		if held_piece == null:
			# Pick up piece
			pass
		else:
			# Put down piece
			pass


func loadBoardState(new_state):
	state = new_state
	
	# Reset Board
	square_map.clear()
	for child in pieces.get_children():
		child.queue_free()
	
	# Load Squares
	for row in range(1, 16):
		for col in range(1, 16):
			if get_bit(state.squares[row], 16 - col - 1):
				square_map.set_cell(Vector2i(col - 8, row - 8), 0, white_tile if (row + col) % 2 == 0 else black_tile)
	
	# Load Pieces
	for piece in state.pieces:
		var instance := piece_scene.instantiate()
		instance.loadPieceData(piece)
		pieces.add_child(instance)


func get_bit(bitfield: int, pos: int) -> int:
	return (bitfield >> pos) & 1
