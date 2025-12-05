# GdUnit generated TestSuite
class_name BoardTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")
# TestSuite generated from
const Source: String = "res://scenes/board/board.gd"


func test_set_difficulty() -> void:
	# Arrange
	var board := Board.new()

	# Assert default value
	assert_str(board.get_difficulty()).is_equal("Medium")

	# Act & Assert: set to Easy
	board.set_difficulty("Easy")
	assert_str(board.get_difficulty()).is_equal("Easy")

	# Act & Assert: set to Hard
	board.set_difficulty("Hard")
	assert_str(board.get_difficulty()).is_equal("Hard")

	# Cleanup
	board.queue_free()
	await get_tree().process_frame  # Give Godot a frame to clean up freed nodes
