class_name Knight
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 3
	self.sprite_index = 1
	super.setup(board, pos, player)


func check_knight_shape(pos: Vector2i) -> bool:
	var hori_diff = pos.x - board_pos.x
	var vert_diff = pos.y - board_pos.y

	return (
		(abs(hori_diff) == 2 and abs(vert_diff) == 1)
		or (abs(hori_diff) == 1 and abs(vert_diff) == 2)
	)


func _movement(pos: Vector2i) -> MovementOutcome:
	# Check knight shape
	if not check_knight_shape(pos):
		return MovementOutcome.BLOCKED

	var piece_to_capture = board.get_piece_at(pos)

	# Can't capture own piece
	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE
