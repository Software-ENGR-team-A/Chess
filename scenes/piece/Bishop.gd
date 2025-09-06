class_name Bishop
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 3
	self.sprite_index = 2
	super.setup(board, pos, player)


func piece_movement(_pos: Vector2i) -> bool:
	return false
