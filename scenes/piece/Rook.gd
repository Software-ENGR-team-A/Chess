class_name Rook
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 5
	self.sprite_index = 3
	super.setup(board, pos, player)


func _movement(pos: Vector2i) -> MovementOutcome:
	var piece_to_capture = board.get_piece_at(pos)
	var hori_diff = pos.x - board_pos.x
	var vert_diff = pos.y - board_pos.y

	# Quick check to crop to cardinal movement
	if not (is_horizontal_move(board_pos, pos) or is_vertical_move(board_pos, pos)):
		return MovementOutcome.BLOCKED

	# Can't capture own piece
	if is_blocked_by_own_piece(piece_to_capture):
		return MovementOutcome.BLOCKED

	var offset = Vector2i(hori_diff, vert_diff)
	var direction = offset.clampi(-1, 1)

	if offset.length() > 1.5:
		# Need to propogate backwards to check line of sight
		var prev_in_path = can_move_to(pos + direction * -1)
		if prev_in_path == MovementOutcome.AVAILABLE:
			return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE

		return MovementOutcome.BLOCKED

	# Immediately touching piece, no need to back-search
	return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE
