class_name Bishop
extends Piece


func setup(pos: Vector2i,player:int):
	self.pointValue = 3
	self.spriteIndex = 2
	super.setup(pos ,player);
	
