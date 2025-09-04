extends Node2D
class_name Piece

@export var player := 0
@export var sprite_index := 0
@export var square_pos: Vector2i


func _ready():
	setSprite(sprite_index);


func loadPieceData(data):
	player = data.player
	sprite_index = data.spriteIndex
	setSquarePos(Vector2i(data.x, data.y))


func setSprite(sprite: int):
	sprite_index = sprite
	$Sprite.frame = sprite_index + player * 32


func setSquarePos(pos: Vector2i):
	square_pos = pos
	set_position(Vector2((pos.x + 1) * 16 - 8, (pos.y) * 16 + 4))


func canMoveTo(pos: Vector2i):
	if square_pos == pos: return false

	if pos.x == square_pos.x: return true
	if pos.y == square_pos.y: return true
	return false
