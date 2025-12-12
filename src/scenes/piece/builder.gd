class_name Builder
extends Piece


func setup(_board: Board, _pos: Vector2i, _player: int) -> void:
	super.setup(_board, _pos, _player)
	self.point_value = 3
	self.anim_name = get_player_name() + "Builder"


func _movement(pos: Vector2i) -> MovementOutcome:
	if pos.distance_to(board_pos) > 1.5:
		return MovementOutcome.BLOCKED

	var piece_to_capture = board.pieces.at(pos)

	# Can't capture own piece
	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE


func movement_actions(pos: Vector2i) -> void:
	var direction = pos - board_pos
	var to_build = pos + direction

	if to_build.clampi(-4, 3) != to_build:
		return

	board.squares.set_at(to_build, true)
