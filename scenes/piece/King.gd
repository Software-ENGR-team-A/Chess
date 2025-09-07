class_name King
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 99999  # Insanely high value that should be tuned with the engine
	self.sprite_index = 5
	super.setup(board, pos, player)


func _movement(pos: Vector2i) -> MovementOutcome:
	var piece_to_capture = board.get_piece_at(pos)
	if piece_to_capture and piece_to_capture.player == player:
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

	var target: Piece

	if pos == original_pos + Vector2i(-2, 0):
		# Check left
		target = look_in_direction(Vector2i(-1, 0), 16)
	elif pos == original_pos + Vector2i(2, 0):
		# Check right
		target = look_in_direction(Vector2i(1, 0), 16)

	if not target:
		return
	if not target is Rook:
		return
	if target.board_pos != target.original_pos:
		return

	return target


func movement_actions(pos: Vector2i) -> void:
	print("KING MOVED")
	var castle_target = get_castle_target_when_moved_to(pos)
	if castle_target:
		print("IS CASTLE")
		print(castle_target)
		var castle_direction = (pos - original_pos).clampi(-1, 1)
		castle_target.set_board_pos(original_pos + castle_direction)


func capture() -> void:
	AudioManager.play_sound(AudioManager.movement.checkmate)
