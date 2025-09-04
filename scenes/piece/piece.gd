class_name Piece
extends Node2D

@export var player := 0 # Black vs White?
@export var sprite_index := 0 # Where in the sprite sheet it exists
@export var point_value := 0 # The point value for the engine
@export var square_pos: Vector2i # It's location on the board

func _ready():
	setSprite(sprite_index);


func loadPieceData(data):
	player = data.player
	sprite_index = data.sprite_index
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
