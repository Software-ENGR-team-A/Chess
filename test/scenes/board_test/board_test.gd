# GdUnit generated TestSuite
class_name BoardTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://scenes/board/board.gd'


func test_promote_white_pawn() -> void:
	var board := Board.new()
	board.pieces = Node.new()
	board.add_child(board.pieces)

	# Spawn a white pawn one tile before promotion
	var start_pos := Vector2i(0, 2)
	var promo_pos := Vector2i(0, 3)
	board.spawn_piece(board.PAWN_SCRIPT, start_pos, 0)
	var pawn := board.get_piece_at(start_pos)
	assert_that(pawn).is_not_null()
	assert_that(pawn).is_instanceof(Pawn)

	# Move pawn to promotion square
	board.move_piece_to(pawn, promo_pos)

	# Assert promotion to Queen
	var promoted := board.get_piece_at(promo_pos)
	assert_that(promoted).is_not_null()
	assert_that(promoted).is_instanceof(Queen)
	assert_that(board.get_piece_at(start_pos)).is_null()
	board.queue_free()


func test_promote_black_pawn() -> void:
	var board := Board.new()
	board.pieces = Node.new()
	board.add_child(board.pieces)

	# Spawn a black pawn one tile before promotion
	var start_pos := Vector2i(1, -3)
	var promo_pos := Vector2i(1, -4)
	board.spawn_piece(board.PAWN_SCRIPT, start_pos, 1)
	var pawn := board.get_piece_at(start_pos)
	assert_that(pawn).is_not_null()
	assert_that(pawn).is_instanceof(Pawn)

	# Move pawn to promotion square
	board.move_piece_to(pawn, promo_pos)

	# Assert promotion to Queen
	var promoted := board.get_piece_at(promo_pos)
	assert_that(promoted).is_not_null()
	assert_that(promoted).is_instanceof(Queen)
	assert_that(board.get_piece_at(start_pos)).is_null()

	board.queue_free()

func test_white_pawn_promotes_on_capture_at_back_rank() -> void:
	var board := Board.new()
	board.pieces = Node.new()
	board.add_child(board.pieces)
	board.start_state = board.DEFAULT_STATE

	# White pawn at (0,2) can capture diagonally to (1,3) — the promotion rank for white.
	var start_pos := Vector2i(0, 2)
	var capture_pos := Vector2i(1, 3)

	# Enemy piece sitting on the promotion square to be captured
	board.spawn_piece(board.PAWN_SCRIPT, capture_pos, 1) # black piece
	board.spawn_piece(board.PAWN_SCRIPT, start_pos, 0)   # white pawn

	var pawn := board.get_piece_at(start_pos)
	assert_that(pawn).is_not_null()
	assert_that(pawn).is_instanceof(Pawn)

	# Capture onto promotion square -> should promote
	board.move_piece_to(pawn, capture_pos)

	var promoted := board.get_piece_at(capture_pos)
	assert_that(promoted).is_not_null()
	assert_that(promoted).is_instanceof(Queen)
	assert_that(board.get_piece_at(start_pos)).is_null()

	board.queue_free()
	
func test_black_pawn_promotes_on_capture_at_back_rank() -> void:
	var board := Board.new()
	board.pieces = Node.new()
	board.add_child(board.pieces)
	board.start_state = board.DEFAULT_STATE

	# Black pawn at (1,-3) can capture diagonally to (0,-4) — the promotion rank for black.
	var start_pos := Vector2i(1, -3)
	var capture_pos := Vector2i(0, -4)

	# Enemy piece sitting on the promotion square to be captured
	board.spawn_piece(board.PAWN_SCRIPT, capture_pos, 0) # white piece
	board.spawn_piece(board.PAWN_SCRIPT, start_pos, 1)   # black pawn

	var pawn := board.get_piece_at(start_pos)
	assert_that(pawn).is_not_null()
	assert_that(pawn).is_instanceof(Pawn)

	# Capture onto promotion square -> should promote
	board.move_piece_to(pawn, capture_pos)

	var promoted := board.get_piece_at(capture_pos)
	assert_that(promoted).is_not_null()
	assert_that(promoted).is_instanceof(Queen)
	assert_that(board.get_piece_at(start_pos)).is_null()
	board.queue_free()

func test_white_pawn_does_not_promote_on_normal_move() -> void:
	var board := Board.new()
	board.pieces = Node.new()
	board.add_child(board.pieces)
	board.start_state = board.DEFAULT_STATE  # Ensure has_floor_at() works

	# White pawn moves forward but not to promotion rank
	var start_pos := Vector2i(0, 1)
	var move_pos := Vector2i(0, 2)
	board.spawn_piece(board.PAWN_SCRIPT, start_pos, 0)

	var pawn := board.get_piece_at(start_pos)
	assert_that(pawn).is_not_null()
	assert_that(pawn).is_instanceof(Pawn)

	# Move forward one square (no promotion)
	board.move_piece_to(pawn, move_pos)

	var result := board.get_piece_at(move_pos)
	assert_that(result).is_not_null()
	assert_that(result).is_instanceof(Pawn)
	assert_that(board.get_piece_at(start_pos)).is_null()
	board.queue_free()

func test_black_pawn_does_not_promote_on_normal_move() -> void:
	var board := Board.new()
	board.pieces = Node.new()
	board.add_child(board.pieces)
	board.start_state = board.DEFAULT_STATE  # Ensure has_floor_at() works

	# Black pawn moves forward but not to promotion rank
	var start_pos := Vector2i(1, -2)
	var move_pos := Vector2i(1, -3)
	board.spawn_piece(board.PAWN_SCRIPT, start_pos, 1)

	var pawn := board.get_piece_at(start_pos)
	assert_that(pawn).is_not_null()
	assert_that(pawn).is_instanceof(Pawn)

	# Move forward one square (no promotion)
	board.move_piece_to(pawn, move_pos)

	var result := board.get_piece_at(move_pos)
	assert_that(result).is_not_null()
	assert_that(result).is_instanceof(Pawn)
	assert_that(board.get_piece_at(start_pos)).is_null()
	board.queue_free()
