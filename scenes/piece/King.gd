class_name King
extends Piece

	
func setup(pos: Vector2i,player:int):
	self.pointValue = 99999 #Insanely high value that should be tuned with the engine
	self.spriteIndex = 4
	super.setup(pos, player);
	
