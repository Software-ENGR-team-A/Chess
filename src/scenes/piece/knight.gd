class_name Knight
extends Piece


func setup(_board: Board, _pos: Vector2i, _player: int) -> void:
	super.setup(_board, _pos, _player)
	point_value = 3
	center_control_multiplier = 2.0
	anim_name = get_player_name() + "Knight"


func check_knight_shape(pos: Vector2i) -> bool:
	var hori_diff = pos.x - board_pos.x
	var vert_diff = pos.y - board_pos.y

	return (
		(abs(hori_diff) == 2 and abs(vert_diff) == 1)
		or (abs(hori_diff) == 1 and abs(vert_diff) == 2)
	)


## Generates and stores all movement outcomes for the piece
func _generate_all_moves() -> void:
	movement_outcome_at(Vector2i(board_pos.x - 2, board_pos.y - 1))
	movement_outcome_at(Vector2i(board_pos.x - 2, board_pos.y + 1))
	movement_outcome_at(Vector2i(board_pos.x + 2, board_pos.y - 1))
	movement_outcome_at(Vector2i(board_pos.x + 2, board_pos.y + 1))
	movement_outcome_at(Vector2i(board_pos.x - 1, board_pos.y - 2))
	movement_outcome_at(Vector2i(board_pos.x - 1, board_pos.y + 2))
	movement_outcome_at(Vector2i(board_pos.x + 1, board_pos.y - 2))
	movement_outcome_at(Vector2i(board_pos.x + 1, board_pos.y + 2))


func _movement(pos: Vector2i) -> MovementOutcome:
	# Check knight shape
	if not check_knight_shape(pos):
		return MovementOutcome.BLOCKED

	var piece_to_capture = board.pieces.at(pos)

	# Can't capture own piece
	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE
