class_name Piece
extends Node2D

@export var player := 0 # Black vs White
@export var squarePos: Vector2i # It's location on the board
@export var hasMoved = false # After the first move, mark as true

var spriteIndex := 0 # Where in the sprite sheet it exists
var pointValue := 0 # The point value for the engine


func _ready():
	self.setSprite(getSpriteIndex())
	setSprite(spriteIndex);


func setup(pos: Vector2i,player: int):
	setSquarePos(pos)
	self.player = player

func setSprite(sprite: int):
	sprite_index = sprite
	$Sprite.frame = sprite_index + player * 32

func setSquarePos(pos: Vector2i):
	square_pos = pos
	set_position(Vector2((pos.x + 1) * 16 - 8, (pos.y) * 16 + 4))


func getSquarePos():
	return squarePos
	
func getSpriteIndex():
	return spriteIndex

func canMoveTo(pos: Vector2i):
	if square_pos == pos: return false

	if pos.x == square_pos.x: return true
	if pos.y == square_pos.y: return true
	return false

