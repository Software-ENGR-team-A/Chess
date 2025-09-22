class_name King
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	super.setup(board, pos, player)
	self.point_value = 99999  # Insanely high value that should be tuned with the engine
	self.anim_name = get_player_name() + "King"


func _movement(pos: Vector2i) -> MovementOutcome:
	var piece_to_capture = board.pieces.at(pos)

	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	if get_castle_target_when_moved_to(pos):
		return MovementOutcome.AVAILABLE

	# Can only move one tile
	if pos.distance_to(board_pos) > 1.5:
		return MovementOutcome.BLOCKED

	return MovementOutcome.CAPTURE if piece_to_capture else MovementOutcome.AVAILABLE


func get_castle_target_when_moved_to(pos: Vector2i) -> Piece:
	if original_pos != board_pos:
		return

	var direction: Vector2i
	if pos == original_pos + Vector2i(-2, 0):
		# Check left
		direction = Vector2i(-1, 0)
	elif pos == original_pos + Vector2i(2, 0):
		# Check right
		direction = Vector2i(1, 0)

	var target = look_in_direction(direction, 16)

	if not target:
		return
	if not target is Rook:
		return
	if target.board_pos != target.original_pos:
		return

	# Can't be in check in any spot along the way
	for i in range(0, 3):
		if in_check_at(board_pos + (i * direction)):
			return

	return target


func in_check() -> Piece:
	return in_check_at(board_pos)


func in_check_at(pos: Vector2i) -> Piece:
	var pieces = board.pieces.get_children()

	for piece in pieces:
		if piece.player == player:
			continue

		if piece.movement_outcome_at(pos):
			return piece

	return null


## Returns if the supplied [param king] is in checkmate based on the current board state.
func in_checkmate() -> bool:
	if in_check():
		# Check every possible move
		for enemy_piece: Piece in board.pieces.get_children():
			if enemy_piece.player != player:
				continue

			if enemy_piece.has_valid_moves():
				return false

		return true
	return false


func movement_actions(pos: Vector2i) -> void:
	var castle_target = get_castle_target_when_moved_to(pos)
	if castle_target:
		var castle_direction = (pos - original_pos).sign()
		castle_target.move_to(original_pos + castle_direction)
