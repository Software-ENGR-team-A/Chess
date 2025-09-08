class_name Bishop
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 3
	self.sprite_index = 2
	super.setup(board, pos, player)


func _movement(pos: Vector2i) -> MovementOutcome:
	var piece_to_capture = board.get_piece_at(pos)

	# Quick check to crop to intercardinal movement
	if not is_diagonal_move(board_pos, pos):
		return MovementOutcome.BLOCKED

	# Can't capture own piece
	if is_blocked_by_own_piece(piece_to_capture):
		return MovementOutcome.BLOCKED

	if not check_line_of_sight(pos):
		return MovementOutcome.BLOCKED

	return check_capture(pos)
