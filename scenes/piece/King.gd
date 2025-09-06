class_name King
extends Piece


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.point_value = 99999  # Insanely high value that should be tuned with the engine
	self.sprite_index = 4
	super.setup(board, pos, player)


func piece_movement(pos: Vector2i) -> bool:
	var piece_to_capture = board.get_piece_at(pos)
	if piece_to_capture and piece_to_capture.player == player:
		return false

	return pos.distance_to(board_pos) <= 1.5
