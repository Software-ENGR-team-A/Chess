class_name Pawn
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 1
	self.sprite_index = 0
	super.setup(board, pos, player)


func can_move_to(pos: Vector2i) -> bool:
	if pos == board_pos:
		return false

	var forward_direction := -1 if player else 1
	var piece_to_capture = board.get_piece_at(pos)

	if piece_to_capture and piece_to_capture.player != player:
		# Check diagonals
		if pos == board_pos + Vector2i( 1, forward_direction): return true
		if pos == board_pos + Vector2i(-1, forward_direction): return true
	else:
		# Single square advance
		if pos == (board_pos + Vector2i(0, forward_direction)):
			return true

		# Check if double advanced is possible
		if pos == (board_pos + Vector2i(0, 2 * forward_direction)):
			if board_pos == original_pos: return true

	return false
