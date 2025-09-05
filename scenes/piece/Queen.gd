class_name Queen
extends Piece


func setup(pos: Vector2i, player: int) -> void:
	self.point_value = 9
	self.sprite_index = 5
	super.setup(pos, player)


func can_move_to(_pos: Vector2i) -> bool:
	return false
