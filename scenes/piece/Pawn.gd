class_name Pawn
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 1
	self.sprite_index = 0
	super.setup(board, pos, player)


func _movement(pos: Vector2i) -> MovementOutcome:
	var piece_to_capture = board.get_piece_at(pos)

	# Can't capture own piece
	if piece_to_capture and piece_to_capture.player == player:
		return MovementOutcome.BLOCKED

	# En passant is also an option
	if not piece_to_capture:
		piece_to_capture = get_en_passant_target(pos)

	if piece_to_capture:
		# Check diagonals
		if pos == board_pos + Vector2i(1, self.forward_direction):
			return MovementOutcome.CAPTURE
		if pos == board_pos + Vector2i(-1, self.forward_direction):
			return MovementOutcome.CAPTURE
	else:
		# Single square advance
		if pos == (board_pos + Vector2i(0, self.forward_direction)):
			return MovementOutcome.AVAILABLE

		# Check if double advanced is possible
		if (
			board_pos == original_pos
			and pos == (board_pos + Vector2i(0, 2 * self.forward_direction))
			and can_move_to(board_pos + Vector2i(0, self.forward_direction))
		):
			return MovementOutcome.AVAILABLE

	return MovementOutcome.BLOCKED


func get_en_passant_target(pos: Vector2i) -> Pawn:
	var target = board.get_piece_at(pos + Vector2i(0, -self.forward_direction))

	# Target must:
	if not target:
		# exist,
		return
	if not target is Pawn:
		# be a pawn,
		return
	if target.player == player:
		# be owned by the opposing team,
		return
	if not target.previous_position or target.last_moved_half_move != board.half_moves - 1:
		# have just moved,
		return
	if target.previous_position + Vector2i(0, 2 * target.forward_direction) != target.board_pos:
		# and have done a double-advance
		return

	return target


func movement_actions(pos: Vector2i) -> void:
	super.movement_actions(pos)

	var en_passant_target = get_en_passant_target(pos)
	if en_passant_target:
		en_passant_target.capture()
