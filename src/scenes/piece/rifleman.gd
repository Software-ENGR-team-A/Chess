class_name Rifleman
extends Piece


func setup(_board: Board, _pos: Vector2i, _player: int) -> void:
	super.setup(_board, _pos, _player)
	self.point_value = 9
	center_control_multiplier = 10.0
	self.anim_name = get_player_name() + "Rifleman"


func _movement(pos: Vector2i) -> MovementOutcome:
	var piece_to_capture = board.pieces.at(pos)

	if piece_to_capture is King:
		return MovementOutcome.BLOCKED

	# Can only move one tile
	if pos.distance_to(board_pos) > 1.5:
		return MovementOutcome.BLOCKED

	if captures_when_moved_to(pos):
		return MovementOutcome.CAPTURE

	return MovementOutcome.AVAILABLE


func captures_when_moved_to(pos: Vector2i) -> Array[Piece]:
	var output: Array[Piece] = []

	for row in range(-8, 8):
		var piece = board.pieces.at(Vector2i(pos.x, row))
		if piece and not piece is King and piece != self:
			output.push_back(piece)

	return output
