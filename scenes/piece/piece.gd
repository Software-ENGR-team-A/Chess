class_name Piece
extends Node2D

@export var player := 0  # Black vs White
@export var square_pos: Vector2i  # It's location on the board
@export var has_moved = false  # After the first move, mark as true

var sprite_index := 0  # Where in the sprite sheet it exists
var point_value := 0  # The point value for the engine


func _ready() -> void:
	self.set_sprite(get_sprite_index())
	set_sprite(sprite_index)


func setup(pos: Vector2i, player: int) -> void:
	set_square_pos(pos)
	self.player = player


func set_sprite(sprite: int) -> void:
	sprite_index = sprite
	$Sprite.frame = sprite_index + player * 32


func set_square_pos(pos: Vector2i) -> void:
	square_pos = pos
	set_position(Vector2((pos.x + 1) * 16 - 8, (pos.y) * 16 + 4))


func get_square_pos() -> Vector2i:
	return square_pos


func get_sprite_index() -> int:
	return sprite_index


func can_move_to(_pos: Vector2i) -> bool:
	return false
