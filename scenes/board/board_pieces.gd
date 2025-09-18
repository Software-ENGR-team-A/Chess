class_name BoardPieces
extends Node2D

const PIECE_SCENE := preload("res://scenes/piece/piece.tscn")

# Nodes
var map: Dictionary = {}
var held_piece: Node
var white_king: King
var black_king: King


func setup(board, pieces_data):
	for child in get_children():
		child.queue_free()

	# Load Pieces
	for piece_data in pieces_data:
		# Iterate through the board, creating instances of each piece
		var piece = spawn_piece(board, piece_data.script, piece_data.pos, piece_data.player)
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


## Returns the [Piece] in the board's [member map] at [param pos], or
## [code]null[/code] if absent.
func at(pos: Vector2i) -> Piece:
	return map.get(pos)


## Creates a scene instance of the piece and places it in the pieces array
##[param piece_script]: The proloaded script for the piece
##[param pos]: The Vector2i for the board location
##[param player]: The player that controls the piece
func spawn_piece(board, piece_script: Script, pos: Vector2i, player: int) -> Piece:
	var new_piece = PIECE_SCENE.instantiate()
	new_piece.set_script(piece_script)
	new_piece.setup(board, pos, player)
	map[pos] = new_piece
	add_child(new_piece)
	new_piece.name = ("White" if player else "Black") + piece_script.get_global_name()
	return new_piece
