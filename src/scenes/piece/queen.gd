class_name Queen
extends Piece


func setup(_board: Board, _pos: Vector2i, _player: int) -> void:
	super.setup(_board, _pos, _player)
	point_value = 9
	center_control_multiplier = 2.0
	anim_name = get_player_name() + "Queen"


## Generates and stores all movement outcomes for the piece
func _generate_all_moves() -> void:
	# Vertical
	for row in range(0, 16):
		var map_cell = Vector2i(board_pos.x, row - 8)
		movement_outcome_at(map_cell)

	# Horizontal
	for col in range(0, 16):
		var map_cell = Vector2i(col - 8, board_pos.y)
		movement_outcome_at(map_cell)

	# Both diagonals
	for offset in range(0, 16):
		movement_outcome_at(Vector2i(board_pos.x - offset, board_pos.y - offset))
		movement_outcome_at(Vector2i(board_pos.x + offset, board_pos.y - offset))


func _movement(pos: Vector2i) -> MovementOutcome:
	var piece_to_capture = board.pieces.at(pos)

	# Can't capture own piece
	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	# Make sure move is a straight line
	if not (is_horizontal(pos) or is_vertical(pos) or is_diagonal(pos)):
		return MovementOutcome.BLOCKED

	if not has_line_of_movement_to(pos):
		return MovementOutcome.BLOCKED

	return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE
