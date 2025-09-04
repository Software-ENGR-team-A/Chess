class_name Piece
extends Node2D

@export var player := 0 # Black vs White
@export var squarePos: Vector2i # It's location on the board
@export var hasMoved = false # After the first move, mark as true

static var spriteIndex := 0 # Where in the sprite sheet it exists
static var pointValue := 0 # The point value for the engine


func _ready():
	setSprite(spriteIndex);


func loadPieceData(data):
	player = data.player
	spriteIndex = data.piece.getSpriteIndex()
	setSquarePos(Vector2i(data.x, data.y))


func setSprite(sprite: int):
	spriteIndex = sprite
	$Sprite.frame = spriteIndex + player * 32

func setSquarePos(pos: Vector2i):
	squarePos = pos
	set_position(Vector2((pos.x + 1) * 16 - 8, (pos.y) * 16 + 4))
	
static func getSpriteIndex():
	return spriteIndex
