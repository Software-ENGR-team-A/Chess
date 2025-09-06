class_name Pawn
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 1
	self.sprite_index = 0
	super.setup(board, pos, player)


func piece_movement(pos: Vector2i) -> movement_outcome:
	var piece_to_capture = board.get_piece_at(pos)
	var forward_direction := -1 if player else 1

	if piece_to_capture and piece_to_capture.player != player:
		# Check diagonals
		if pos == board_pos + Vector2i(1, forward_direction):
			return movement_outcome.CAPTURE
		if pos == board_pos + Vector2i(-1, forward_direction):
			return movement_outcome.CAPTURE
	else:
		# Single square advance
		if pos == (board_pos + Vector2i(0, forward_direction)):
			return movement_outcome.AVAILABLE

		# Check if double advanced is possible
		if (
			board_pos == original_pos
			and pos == (board_pos + Vector2i(0, 2 * forward_direction))
			and can_move_to(board_pos + Vector2i(0, forward_direction))
		):
			return movement_outcome.AVAILABLE

	return movement_outcome.BLOCKED
