# GdUnit generated TestSuite
class_name BoardTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")
# TestSuite generated from
const SOURCE: String = "res://scenes/board/board.gd"

const BOARD_SCENE := preload("res://scenes/board/board.tscn")
const BOARD_PIECES_SCRIPT := preload("res://scenes/board/board_pieces.gd")
const PAWN_SCRIPT := preload("res://scenes/piece/pawn.gd")
const ROOK_SCRIPT := preload("res://scenes/piece/rook.gd")
const KNIGHT_SCRIPT := preload("res://scenes/piece/knight.gd")
const BISHOP_SCRIPT := preload("res://scenes/piece/bishop.gd")
const QUEEN_SCRIPT := preload("res://scenes/piece/queen.gd")
const KING_SCRIPT := preload("res://scenes/piece/king.gd")

var default_squares := [
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000
]

var default_pieces_data := [
	# White Front Row
	{"script": PAWN_SCRIPT, "pos": Vector2i(-4, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-3, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-2, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-1, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(0, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(1, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(2, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(3, -3), "player": 0},
	# White Back Row
	{"script": ROOK_SCRIPT, "pos": Vector2i(-4, -4), "player": 0},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(-3, -4), "player": 0},
	{"script": BISHOP_SCRIPT, "pos": Vector2i(-2, -4), "player": 0},
	{"script": KING_SCRIPT, "pos": Vector2i(-1, -4), "player": 0},
	{"script": QUEEN_SCRIPT, "pos": Vector2i(0, -4), "player": 0},
	{"script": BISHOP_SCRIPT, "pos": Vector2i(1, -4), "player": 0},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(2, -4), "player": 0},
	{"script": ROOK_SCRIPT, "pos": Vector2i(3, -4), "player": 0},
	# Black Front Row
	{"script": PAWN_SCRIPT, "pos": Vector2i(-4, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-3, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-2, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-1, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(0, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(1, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(2, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(3, 2), "player": 1},
	# Black Back Row
	{"script": ROOK_SCRIPT, "pos": Vector2i(-4, 3), "player": 1},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(-3, 3), "player": 1},
	{"script": BISHOP_SCRIPT, "pos": Vector2i(-2, 3), "player": 1},
	{"script": KING_SCRIPT, "pos": Vector2i(-1, 3), "player": 1},
	{"script": QUEEN_SCRIPT, "pos": Vector2i(0, 3), "player": 1},
	{"script": BISHOP_SCRIPT, "pos": Vector2i(1, 3), "player": 1},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(2, 3), "player": 1},
	{"script": ROOK_SCRIPT, "pos": Vector2i(3, 3), "player": 1}
]


func test_setup_loads_data() -> void:
	var b = BOARD_SCENE.instantiate()
	var new_pieces = BOARD_PIECES_SCRIPT.generate_pieces_from_data(default_pieces_data)

	# Ensure board starts empty
	assert_array(b.pieces.get_children()).is_empty()
	assert_array(b.squares.floor_data).is_empty()

	# Setup board
	b.setup(false, default_squares, new_pieces)

	# Make sure the board is loaded with the correct data
	assert_that(b.is_primary).is_equal(false)
	assert_array(b.pieces.get_children()).is_equal(new_pieces)
	assert_array(b.squares.floor_data).is_equal(default_squares)

	# Clear
	b.queue_free()


func test_branching() -> void:
	var b = BOARD_SCENE.instantiate()
	var new_pieces = BOARD_PIECES_SCRIPT.generate_pieces_from_data(default_pieces_data)
	b.setup(false, default_squares, new_pieces)

	# Create a copy of the board state
	var branched = b.branch()

	# Ensure the pieces match
	var original_pieces = b.pieces.get_children()

	for piece in original_pieces:
		# Ensure the branched board has a copy
		# of the piece at the expected location
		var mirror_piece = branched.pieces.at(piece.board_pos)
		assert_that(mirror_piece).is_not_null()

		# Ensure the branched piece is the
		# same type of piece as the original
		var piece_name = piece.get_script().get_global_name()
		var mirror_piece_name = piece.get_script().get_global_name()
		assert_that(piece_name).is_equal(mirror_piece_name)

	# Ensure the tiles match
	var original_tiles = b.squares.floor_data
	var branched_tiles = branched.squares.floor_data
	assert_that(original_tiles).is_equal(branched_tiles)

	# Clear
	b.queue_free()
	branched.queue_free()


func test_look_in_direction() -> void:
	var b = BOARD_SCENE.instantiate()
	var new_pieces = BOARD_PIECES_SCRIPT.generate_pieces_from_data(default_pieces_data)
	b.setup(false, default_squares, new_pieces)

	var center_square = Vector2i(0, 0)

	# Looking up from a central piece, we should find a black pawn.
	var up_piece = b.look_in_direction(center_square, Vector2i(0, 1), 16)
	assert_that(up_piece).is_not_null()
	assert_that(up_piece.get_player_name()).is_equal("Black")

	# Looking up from a central piece, we should find a white pawn.
	var down_piece = b.look_in_direction(center_square, Vector2i(0, -1), 16)
	assert_that(down_piece).is_not_null()
	assert_that(down_piece.get_player_name()).is_equal("White")

	# There should be no pieces to the left and right from center
	var left_piece = b.look_in_direction(center_square, Vector2i(-1, 0), 16)
	assert_that(left_piece).is_null()

	# Looking up but in a very short max distance should also return no piece
	var too_shortsighted_to_see = b.look_in_direction(center_square, Vector2i(0, 1), 1)
	assert_that(too_shortsighted_to_see).is_null()

	# Clear
	b.queue_free()


func test_set_difficulty() -> void:
	# Arrange
	var board := Board.new()

	# Assert default value
	assert_str(board.get_difficulty()).is_equal("Medium")

	# Act & Assert: set to Easy
	board.set_difficulty(0)
	assert_str(board.get_difficulty()).is_equal("Easy")

	# Act & Assert: set to Hard
	board.set_difficulty(2)
	assert_str(board.get_difficulty()).is_equal("Hard")

	# Cleanup
	board.queue_free()
	await get_tree().process_frame  # Give Godot a frame to clean up freed nodes
