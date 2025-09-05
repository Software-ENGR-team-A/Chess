class_name Queen
extends Piece

func setup(pos: Vector2i,player:int):
	self.pointValue = 9
	self.spriteIndex = 5
	super.setup(pos, player);
