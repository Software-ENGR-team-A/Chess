class_name Knight
extends Piece

func setup(pos: Vector2i,player:int):
	self.pointValue = 3
	self.spriteIndex = 1
	super.setup(pos, player);