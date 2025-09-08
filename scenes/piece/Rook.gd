class_name Rook
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 5
	self.sprite_index = 3
	super.setup(board, pos, player)


func _movement(pos: Vector2i) -> MovementOutcome:
	var piece_to_capture = board.get_piece_at(pos)

	# Quick check to crop to cardinal movement
	if not (is_horizontal_move(board_pos, pos) or is_vertical_move(board_pos, pos)):
		return MovementOutcome.BLOCKED

	# Can't capture own piece
	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	return check_line_of_sight(pos)
