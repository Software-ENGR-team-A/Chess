class_name ChessEngine

var root_board: Board

func _init(_root_board: Board) -> void:
	root_board = _root_board


func generate_moves_for(board: Board) -> Array[Move]:
	var moves: Array[Move] = []

	for piece in board.pieces.get_children():
		if board.half_moves % 2 != piece.player:
			continue

		piece.generate_all_moves()
		for position in piece.valid_moves:
			moves.push_back(Move.new(piece, position))
	
	return moves


func make_random_move_for(board: Board) -> void:
	var moves = generate_moves_for(board)

	if moves.size() > 0:
		var move = moves.get(randi() % moves.size())
		move.piece.move_to(move.board_pos)
		board.half_moves += 1
