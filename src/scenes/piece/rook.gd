class_name Rook
extends Piece


func setup(_board: Board, _pos: Vector2i, _player: int) -> void:
	super.setup(_board, _pos, _player)
	point_value = 5
	anim_name = get_player_name() + "Rook"


func _movement(pos: Vector2i) -> MovementOutcome:
	# Quick check to crop to cardinal movement
	if not (is_horizontal(pos) or is_vertical(pos)):
		return MovementOutcome.BLOCKED

	var piece_to_capture = board.pieces.at(pos)

	# Can't capture own piece
	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	if not has_line_of_movement_to(pos):
		return MovementOutcome.BLOCKED

	return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE
