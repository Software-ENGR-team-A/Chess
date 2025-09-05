class_name Piece
extends Node2D

@export var player := 0 # Black vs White
@export var square_pos: Vector2i # It's location on the board
@export var has_moved = false # After the first move, mark as true

var sprite_index := 0 # Where in the sprite sheet it exists
var point_value := 0 # The point value for the engine


func _ready() -> void:
	self.setSprite(getSpriteIndex())
	setSprite(sprite_index);


func setup(pos: Vector2i, player: int) -> void:
	setSquarePos(pos)
	self.player = player

func setSprite(sprite: int) -> void:
	sprite_index = sprite
	$Sprite.frame = sprite_index + player * 32

func setSquarePos(pos: Vector2i) -> void:
	square_pos = pos
	set_position(Vector2((pos.x + 1) * 16 - 8, (pos.y) * 16 + 4))


func getSquarePos() -> Vector2i:
	return square_pos
	
func getSpriteIndex() -> int:
	return sprite_index

func canMoveTo(pos: Vector2i) -> bool:
	return false
	if square_pos == pos: return false

	if pos.x == square_pos.x: return true
	if pos.y == square_pos.y: return true
	return false

