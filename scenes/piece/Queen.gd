class_name Queen
extends Piece


func setup(_board: Board, _pos: Vector2i, _player: int) -> void:
	super.setup(_board, _pos, _player)
	point_value = 9
	anim_name = get_player_name() + "Queen"


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
