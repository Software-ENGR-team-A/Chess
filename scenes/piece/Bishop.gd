class_name Bishop
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 3
	self.sprite_index = 2
	super.setup(board, pos, player)


func piece_movement(pos: Vector2i) -> movement_outcome:
	var piece_to_capture = board.get_piece_at(pos)
	var hori_diff = pos.x - board_pos.x
	var vert_diff = pos.y - board_pos.y

	# Quick check to crop to intercardinal movement
	if abs(hori_diff) != abs(vert_diff):
		return movement_outcome.BLOCKED

	# Can't capture own piece
	if piece_to_capture and piece_to_capture.player == player:
		return movement_outcome.BLOCKED

	var offset = Vector2i(hori_diff, vert_diff)
	var direction = offset.clampi(-1, 1)

	if offset.length() > 1.5:
		# Need to propogate backwards to check line of sight
		var prev_in_path = can_move_to(pos + direction * -1)
		if prev_in_path == movement_outcome.AVAILABLE:
			return movement_outcome.CAPTURE if piece_to_capture else movement_outcome.AVAILABLE
		else:
			return movement_outcome.BLOCKED
	else:
		# Immediately touching piece, no need to back-search
		return movement_outcome.CAPTURE if piece_to_capture else movement_outcome.AVAILABLE
