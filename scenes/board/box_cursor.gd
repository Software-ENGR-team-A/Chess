class_name BoxCursor
extends Sprite2D

const TIME_TO_LERP := 0.05
var time_to_lerp = 0.0
var lerp_target: Vector2i

var lerp_pos: Vector2


func set_board_pos(pos: Vector2i) -> void:
	lerp_target = pos * 16
	lerp_pos = pos * 16
	time_to_lerp = 0


func lerp_to_board_pos(pos: Vector2i) -> void:
	if lerp_target == pos:
		return

	time_to_lerp = TIME_TO_LERP
	lerp_target = pos * 16


func _process(delta: float) -> void:
	if time_to_lerp > 0:
		time_to_lerp -= delta
		if time_to_lerp < 0:
			time_to_lerp = 0

	lerp_pos = lerp_pos.lerp(lerp_target, 1 - (time_to_lerp / TIME_TO_LERP))
	position = lerp_pos.round()
