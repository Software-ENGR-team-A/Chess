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
		piece_to_capture = en_passant_to_capture_when_moved_to(pos)

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


func en_passant_to_capture_when_moved_to(pos: Vector2i) -> Pawn:
	var forward_direction := -1 if player else 1

	var en_passant_to_capture = board.get_piece_at(pos + Vector2i(0, -self.forward_direction))
	if (
		en_passant_to_capture
		and en_passant_to_capture is Pawn
		and en_passant_to_capture.player != player
		and en_passant_to_capture.last_moved_half_move == board.half_moves - 1
		and (
			en_passant_to_capture.board_pos
			== (
				en_passant_to_capture.original_pos
				+ Vector2i(0, 2 * en_passant_to_capture.forward_direction)
			)
		)
	):
		return en_passant_to_capture

	return null


func additional_captures_when_moved_to(pos: Vector2i) -> Array[Piece]:
	var output: Array[Piece] = []
	var en_passant = en_passant_to_capture_when_moved_to(pos)
	if en_passant:
		output.push_back(en_passant)
	return output
