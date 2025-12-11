# GdUnit generated TestSuite
class_name PawnTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")

const __source := "res://scenes/piece/pawn.gd"

# ------------------------------------------------------------------------
# DOUBLES
# ------------------------------------------------------------------------

class DummyPieces:
	extends Node
	var map: Dictionary = {}

	func at(pos: Vector2i) -> Piece:
		return map.get(pos)

	func pick_up(_piece): pass


class DummyBoard:
	extends Board

	func _init() -> void:
		# Replace the real pieces node
		if has_node("pieces"):
			var old = get_node("pieces")
			remove_child(old)
			old.queue_free()

		var dummy := DummyPieces.new()
		add_child(dummy)
		pieces = dummy


# ------------------------------------------------------------------------
# HELPERS
# ------------------------------------------------------------------------

func _new_pawn(board: DummyBoard, pos: Vector2i, player: int, fdir: int) -> Pawn:
	var p = load(__source).new() as Pawn
	board.pieces.add_child(p)
	p.board = board
	p.player = player
	p.original_pos = pos
	p.board_pos = pos
	p.forward_direction = fdir
	board.pieces.map[pos] = p
	return p

func _map_contains(board: DummyBoard, piece: Piece) -> bool:
	for v in board.pieces.map.values():
		if v == piece:
			return true
	return false


# ------------------------------------------------------------------------
# TESTS
# ------------------------------------------------------------------------

func test_pawn_promotion() -> void:
	# forward_direction = 1 promotes at y == 3
	var b1 := DummyBoard.new()
	var pawn1 := _new_pawn(b1, Vector2i(0,2), 0, 1)
	b1.half_moves = 4
	pawn1.move_to(Vector2i(0,3))

	var q1 = b1.pieces.map.get(Vector2i(0,3))
	assert_that(q1).is_not_null()
	assert_bool(q1 is Pawn).is_false()
	assert_str(q1.get_script().resource_path).is_equal("res://scenes/piece/queen.gd")
	assert_bool(_map_contains(b1, pawn1)).is_false()

	# forward_direction = -1 promotes at y == -4
	var b2 := DummyBoard.new()
	var pawn2 := _new_pawn(b2, Vector2i(1,-3), 1, -1)
	b2.half_moves = 8
	pawn2.move_to(Vector2i(1,-4))

	var q2 = b2.pieces.map.get(Vector2i(1,-4))
	assert_that(q2).is_not_null()
	assert_bool(q2 is Pawn).is_false()
	assert_str(q2.get_script().resource_path).is_equal("res://scenes/piece/queen.gd")
	assert_bool(_map_contains(b2, pawn2)).is_false()


func test_en_passant_positive_forward() -> void:
	var board := DummyBoard.new()
	board.half_moves = 10

	# Capturing pawn (white, moves +y)
	var capturer := _new_pawn(board, Vector2i(0,1), 0, 1)

	# Target pawn double-advanced to (1,1)
	var target := _new_pawn(board, Vector2i(1,1), 1, -1)
	target.previous_position = Vector2i(1,3)
	target.last_moved_half_move = 9  # board.half_moves - 1

	capturer.move_to(Vector2i(1,2))

	assert_that(board.pieces.map.get(Vector2i(1,2))).is_equal(capturer)
	assert_bool(_map_contains(board, target)).is_false()


func test_en_passant_negative_forward() -> void:
	var board := DummyBoard.new()
	board.half_moves = 30

	# Capturing pawn (black, moves -y)
	var capturer := _new_pawn(board, Vector2i(0,-1), 1, -1)

	# Target pawn double-advanced to (1,-1)
	var target := _new_pawn(board, Vector2i(1,-1), 0, 1)
	target.previous_position = Vector2i(1,-3)
	target.last_moved_half_move = 29

	capturer.move_to(Vector2i(1,-2))

	assert_that(board.pieces.map.get(Vector2i(1,-2))).is_equal(capturer)
	assert_bool(_map_contains(board, target)).is_false()
