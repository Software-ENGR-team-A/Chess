class_name Rook
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 5
	self.sprite_index = 3
	super.setup(board, pos, player)


func _movement(pos: Vector2i) -> MovementOutcome:
	# Quick check to crop to cardinal movement
	if not (is_horizontal(pos) or is_vertical(pos)):
		return MovementOutcome.BLOCKED

	var piece_to_capture = board.get_piece_at(pos)

	# Can't capture own piece
	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	if not has_line_of_movement_to(pos):
		return MovementOutcome.BLOCKED

	return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE
