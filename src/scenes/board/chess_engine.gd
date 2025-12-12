class_name ChessEngine

const VARIABILITY := 1.0
#const VARIABILITY := 0.0

var root_board: Board

var worker_thread: Thread = Thread.new()
var is_working := false


func _init(_root_board: Board) -> void:
	root_board = _root_board


func make_move(board: Board) -> void:
	# make_best_shallow_move_for(board)

	var decided_outcome = recursive_move_check(board, 1)
	if decided_outcome:
		score_move(decided_outcome, true)
		decided_outcome.perform()


func recursive_move_check(board: Board, layer: int) -> Move:
	# Base case, just make best move
	if layer == 0:
		return get_best_shallow_move_for(board)

	# Other cases, we want to create a new timeline for each valid next move,
	# recursively find the next best valid move after that, and return the best
	# overall move based on their combined outcome
	var best_moves: Array[Move] = []
	var best_move_points: float = -INF

	var moves := get_possible_moves_for(board)

	if moves.size() == 0:
		return null

	for move in moves:
		var new_timeline := board.branch()

		var tl_piece = new_timeline.pieces.at(move.piece.board_pos)
		var tl_move = Move.new(tl_piece, move.board_pos)

		var move_points := score_move(tl_move)
		tl_move.perform()

		# Because the next move is performed for the *enemy* player,
		# we want to subtract how good their best move was
		move_points -= score_move(recursive_move_check(new_timeline, layer - 1))

		new_timeline.queue_free()

		if move_points > best_move_points + VARIABILITY:
			best_moves = []
			best_move_points = move_points

		if move_points >= best_move_points:
			best_moves.push_back(move)

	var random_good_move: Move = best_moves[randi() % best_moves.size()]
	return random_good_move


func get_best_shallow_move_for(board: Board) -> Move:
	var moves := get_possible_moves_for(board)

	if moves.size() == 0:
		return null

	var best_moves: Array[Move] = []
	var best_move_points: float = -INF

	for move in moves:
		var move_points = score_move(move)

		if move_points > best_move_points + VARIABILITY:
			best_moves = []
			best_move_points = move_points

		if move_points >= best_move_points:
			best_moves.push_back(move)

	var random_good_move = best_moves[randi() % best_moves.size()]
	return random_good_move


func get_possible_moves_for(board: Board) -> Array[Move]:
	var moves: Array[Move] = []

	for piece in board.pieces.get_children():
		if piece == null or board.half_moves % 2 != piece.player:
			continue

		piece._generate_all_moves()
		for position in piece.valid_moves:
			moves.push_back(Move.new(piece, position))

	return moves


func score_move(move: Move, debug: bool = false) -> float:
	var points := 0.0

	# Add score for captures
	for capture in move.piece.captures_when_moved_to(move.board_pos):
		if debug:
			print(
				"\t" + str(round(capture.point_value * 4)) + " points for capturing " + str(capture)
			)

		points += capture.point_value * 4

	# Remove points for poor centre control
	var center_bonus = 8 - Vector2(move.board_pos).distance_to(Vector2(-0.5, -0.5))
	center_bonus *= move.piece.center_control_multiplier / 2
	#
	points += center_bonus

	if debug:
		print("\t" + str(round(center_bonus)) + " points for centre bonus")

	if debug:
		print(str(round(points)) + " points total")

	return points
