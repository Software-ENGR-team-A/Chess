class_name Knight
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 3
	self.sprite_index = 1
	super.setup(board, pos, player)


func can_move_to(_pos: Vector2i) -> bool:
	return false
