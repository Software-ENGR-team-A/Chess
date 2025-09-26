class_name Move

var piece: Piece
var board_pos: Vector2i


func _init(_piece: Piece, _board_pos: Vector2i):
	assert(_piece != null)
	piece = _piece
	board_pos = _board_pos


func perform() -> void:
	piece.move_to(board_pos)
	piece.board.half_moves += 1
