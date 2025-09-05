class_name Pawn 
extends Piece

func setup(pos: Vector2i, player:int) -> void:
	self.point_value = 1
	self.sprite_index = 0
	super.setup(pos, player);



func canMoveTo(pos: Vector2i) -> bool:
	return false
