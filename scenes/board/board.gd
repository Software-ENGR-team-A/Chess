extends Node2D

const piece_scene := preload("res://scenes/piece/piece.tscn");

const PawnScript = preload("res://scenes/piece/Pawn.gd")
const RookScript = preload("res://scenes/piece/Rook.gd")
const KnightScript = preload("res://scenes/piece/Knight.gd")
const BishopScript = preload("res://scenes/piece/Bishop.gd")
const QueenScript = preload("res://scenes/piece/Queen.gd")
const KingScript = preload("res://scenes/piece/King.gd")

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
		{ "script": PawnScript, "pos": Vector2i(-4,-3), "player": 0 },
		{ "script": PawnScript, "pos": Vector2i(-3,-3), "player": 0 },
		{ "script": PawnScript, "pos": Vector2i(-2,-3), "player": 0 },
		{ "script": PawnScript, "pos": Vector2i(-1,-3), "player": 0 },
		{ "script": PawnScript, "pos": Vector2i(0,-3), "player": 0 },
		{ "script": PawnScript, "pos": Vector2i(1,-3), "player": 0 },
		{ "script": PawnScript, "pos": Vector2i(2,-3), "player": 0 },
		{ "script": PawnScript, "pos": Vector2i(3,-3), "player": 0 },
		
		# White Back Row
		{ "script": RookScript, "pos": Vector2i(-4,-4), "player": 0 },
		{ "script": KnightScript, "pos": Vector2i(-3,-4), "player": 0 },
		{ "script": BishopScript, "pos": Vector2i(-2,-4), "player": 0 },
		{ "script": QueenScript, "pos": Vector2i(-1,-4), "player": 0 },
		{ "script": KingScript, "pos": Vector2i(0,-4), "player": 0 },
		{ "script": BishopScript, "pos": Vector2i(1,-4), "player": 0 },
		{ "script": KnightScript, "pos": Vector2i(2,-4), "player": 0 },
		{ "script": RookScript, "pos": Vector2i(3,-4), "player": 0 },

		# Black Front Row
		{ "script": PawnScript, "pos": Vector2i(-4,2), "player": 1 },
		{ "script": PawnScript, "pos": Vector2i(-3,2), "player": 1 },
		{ "script": PawnScript, "pos": Vector2i(-2,2), "player": 1 },
		{ "script": PawnScript, "pos": Vector2i(-1,2), "player": 1 },
		{ "script": PawnScript, "pos": Vector2i(0,2), "player": 1 },
		{ "script": PawnScript, "pos": Vector2i(1,2), "player": 1 },
		{ "script": PawnScript, "pos": Vector2i(2,2), "player": 1 },
		{ "script": PawnScript, "pos": Vector2i(3,2), "player": 1 },
			
		# Black Back Row
		{ "script": RookScript, "pos": Vector2i(-4,3), "player": 1 },
		{ "script": KnightScript, "pos": Vector2i(-3,3), "player": 1 },
		{ "script": BishopScript, "pos": Vector2i(-2,3), "player": 1 },
		{ "script": QueenScript, "pos": Vector2i(0,3), "player": 1 },
		{ "script": KingScript, "pos": Vector2i(-1,3), "player": 1 },
		{ "script": BishopScript, "pos": Vector2i(1,3), "player": 1 },
		{ "script": KnightScript, "pos": Vector2i(2,3), "player": 1 },
		{ "script": RookScript, "pos": Vector2i(3,3), "player": 1 }
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

func spawnPiece(piece_script: Script, position: Vector2i, player: int):
	var new_piece = piece_scene.instantiate()
	new_piece.set_script(piece_script)
	new_piece.setup(position.x, position.y, player)
	piece_map[position] = new_piece
	pieces.add_child(new_piece)

func _ready():
	square_map = $Squares
	pieces = $Pieces
	loadBoardState(default_state)


func _process(_delta):
	pass


func _input(event):
	var hovered_square = square_map.local_to_map(square_map.get_local_mouse_position())

	var vport = get_viewport()
	var screen_mouse_position = vport.get_mouse_position() # Get the mouse position on the screen
	var world_pos = (vport.get_screen_transform() * vport.get_canvas_transform()).affine_inverse() * screen_mouse_position
	
	if held_piece != null:
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
		elif checkFloor(hovered_square):
			# Put down piece
			movePiece(held_piece, hovered_square)
			held_piece = null
		else:
			movePiece(held_piece, held_piece.squarePos)
			held_piece = null


func loadBoardState(new_state):
	state = new_state

	# Reset Board
	square_map.clear()
	for child in pieces.get_children():
		child.queue_free()
	
	# Load Squares
	for row in range(0, 16):
		for col in range(0, 16):
			var map_cell = Vector2i(col - 8, row - 8)
			if checkFloor(map_cell):
				square_map.set_cell(map_cell, 0, white_tile if (row + col) % 2 == 0 else black_tile)
	
	# Load Pieces
	for piece_data in state.pieces:
		spawnPiece(piece_data.script, piece_data.pos, piece_data.player)


func movePiece(piece: Node, pos: Vector2i):
	# Pick up original piece
	piece_map.set(piece.squarePos, null)

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
	
# Add this method to board.gd
