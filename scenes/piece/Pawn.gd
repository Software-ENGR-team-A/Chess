class_name Pawn 
extends Piece

func setup(pos: Vector2i,player:int):
	self.pointValue = 1
	self.spriteIndex = 0
	super.setup(pos, player);
