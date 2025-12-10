class_name Bishop
extends Piece


func setup(_board: Board, _pos: Vector2i, _player: int) -> void:
	super.setup(_board, _pos, _player)
	point_value = 3
	center_control_multiplier = 3.0
	anim_name = get_player_name() + "Bishop"


## Generates and stores all movement outcomes for the piece
func _generate_all_moves() -> void:
	for offset in range(0, 16):
		movement_outcome_at(Vector2i(board_pos.x - offset, board_pos.y - offset))
		movement_outcome_at(Vector2i(board_pos.x + offset, board_pos.y - offset))


func _movement(pos: Vector2i) -> MovementOutcome:
	# Quick check to crop to intercardinal movement
	if not is_diagonal(pos):
		return MovementOutcome.BLOCKED

	var piece_to_capture = board.pieces.at(pos)

	# Can't capture own piece
	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	if not has_line_of_movement_to(pos):
		return MovementOutcome.BLOCKED

	return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE
