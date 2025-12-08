class_name BoxCursor
extends Sprite2D

var lerp_target: Vector2


func set_board_pos(pos: Vector2i) -> void:
	position = Vector2(pos) * 16


func lerp_to_board_pos(pos: Vector2i) -> void:
	if lerp_target == Vector2(pos):
		return

	lerp_target = pos * 16

	var tween = create_tween()
	tween.tween_property(self, "position", lerp_target, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(
		Tween.EASE_OUT
	)
