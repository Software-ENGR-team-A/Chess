class_name Queen
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 9
	self.sprite_index = 4
	super.setup(board, pos, player)


func _movement(pos: Vector2i) -> MovementOutcome:
	var piece_to_capture = board.get_piece_at(pos)

	# Can't capture own piece
	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	# Make sure move is a straight line
	if not (is_horizontal(pos) or is_vertical(pos) or is_diagonal(pos)):
		return MovementOutcome.BLOCKED

	if not has_line_of_movement_to(pos):
		return MovementOutcome.BLOCKED

	return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE
