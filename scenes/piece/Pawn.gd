class_name Pawn 
extends Piece

func setup(x:int,y:int,player:int):
	self.pointValue = 1
	self.spriteIndex = 0
	super.setup(x,y,player);
