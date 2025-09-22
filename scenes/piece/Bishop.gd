class_name Bishop
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	super.setup(board, pos, player)
	self.point_value = 3
	self.anim_name = get_player_name() + "Bishop"


func _movement(pos: Vector2i) -> MovementOutcome:
	# Quick check to crop to intercardinal movement
	if not is_diagonal(pos):
		return MovementOutcome.BLOCKED

	var piece_to_capture = board.pieces.at(pos)

	# Can't capture own piece
	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	if not has_line_of_movement_to(pos):
		return MovementOutcome.BLOCKED

	return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE
