class_name Rook
extends Piece

func setup(pos: Vector2i,player:int):
	self.pointValue = 5
	self.spriteIndex = 3
	super.setup(pos, player);
