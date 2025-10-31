# GdUnit generated TestSuite
class_name BoardTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://scenes/board/board.gd'



func test_set_turn() -> void:
	# remove this line and complete your test
	var runner = scene_runner("res://scenes/board/board.tscn")
	var turn_indicator = runner.invoke("find_child", "TurnIndicator")
	assert(turn_indicator.text == "1\nWhite")
	runner.invoke("set_turn", 10)
	assert(turn_indicator.text == "10\nBlack")
	runner.invoke("set_turn", 99)
	assert(turn_indicator.text == "99\nWhite")
	runner.invoke("set_turn", 1000)
	assert(turn_indicator.text == "1000\nBlack")
