class_name Piece
extends Node2D

@export var player := 0  # Black vs White
@export var board_pos: Vector2i
@export var original_pos: Vector2i

var sprite_index := 0  # Where in the sprite sheet it exists
var point_value := 0  # The point value for the engine
var board: Board


func _ready() -> void:
	self.set_sprite(get_sprite_index())
	set_sprite(sprite_index)


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.board = board
	set_board_pos(pos)
	original_pos = board_pos
	self.player = player


func set_sprite(sprite: int) -> void:
	sprite_index = sprite
	$Sprite.frame = sprite_index + player * 32


func set_board_pos(pos: Vector2i) -> void:
	board_pos = pos
	set_position(Vector2((pos.x + 1) * 16 - 8, (pos.y) * 16 + 4))


func get_board_pos() -> Vector2i:
	return board_pos


func get_sprite_index() -> int:
	return sprite_index


func can_move_to(_pos: Vector2i) -> bool:
	return false
