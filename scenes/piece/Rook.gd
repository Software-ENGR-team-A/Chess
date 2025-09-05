class_name Rook
extends Piece

func setup(x:int,y:int,player:int):
	self.pointValue = 5
	self.spriteIndex = 3
	super.setup(x,y,player);
