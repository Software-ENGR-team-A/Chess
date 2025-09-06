class_name King
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 99999  # Insanely high value that should be tuned with the engine
	self.sprite_index = 4
	super.setup(board, pos, player)


func can_move_to(_pos: Vector2i) -> bool:
	return false
