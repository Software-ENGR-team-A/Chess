class_name Roach
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	super.setup(board, pos, player)
	self.point_value = 3
	self.anim_name = get_player_name() + "Roach"


func _movement(pos: Vector2i) -> MovementOutcome:
	if not is_diagonal(pos) or pos.distance_to(board_pos) > 1.5:
		return MovementOutcome.BLOCKED

	var piece_to_capture = board.pieces.at(pos)

	# Can't capture own piece
	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE


func movement_actions(_pos: Vector2i) -> void:
	if board.half_moves % 2 == self.player:
		board.squares.set_at(board_pos, false)


func capture() -> void:
	var valid_locations = []
	for i in range(-1, 1):
		for j in range(-1, 1):
			if i == 0 and j == 0:
				continue
			var location = board_pos + Vector2i(i, j)
			if board.squares.has_floor_at(location) and not board.pieces.at(location):
				valid_locations.push_back(location)

	if valid_locations.size() == 0:
		return super.capture()

	move_to(valid_locations.get(randi() % valid_locations.size()))
