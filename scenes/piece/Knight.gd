class_name Knight
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 3
	self.sprite_index = 1
	super.setup(board, pos, player)


func piece_movement(pos: Vector2i) -> movement_outcome:
	var piece_to_capture = board.get_piece_at(pos)
	var hori_diff = pos.x - board_pos.x
	var vert_diff = pos.y - board_pos.y

	# Can't capture own piece
	if piece_to_capture and piece_to_capture.player == player:
		return movement_outcome.BLOCKED

	# Check knight shape
	if not (abs(hori_diff) == 2 and abs(vert_diff) == 1
		or abs(hori_diff) == 1 and abs(vert_diff) == 2
	):
		return movement_outcome.BLOCKED

	return movement_outcome.CAPTURE if piece_to_capture else movement_outcome.AVAILABLE
