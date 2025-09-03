extends Node2D

@export var player := 0
@export var spriteIndex := 0
@export var squarePos: Vector2i


func _ready():
	setSprite(spriteIndex);


func loadPieceData(data):
	player = data.player
	spriteIndex = data.spriteIndex
	setSquarePos(Vector2i(data.x, data.y))


func setSprite(sprite: int):
	spriteIndex = sprite
	$Sprite.frame = spriteIndex + player * 32


func setSquarePos(pos: Vector2i):
	squarePos = pos
	set_position(Vector2((pos.x + 1) * 16 - 8, (pos.y) * 16 + 4))
