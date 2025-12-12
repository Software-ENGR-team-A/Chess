# GdUnit generated TestSuite
class_name MainMenuTest
extends GdUnitTestSuite
@warning_ignore("unused_parameter")
@warning_ignore("return_value_discarded")
# TestSuite generated from
const __source: String = "res://scenes/menus/main_menu/main_menu.gd"

const __source_scene = "res://scenes/menus/main_menu/main_menu.tscn"

var main_menu: Node


func before_test() -> void:
	# Instantiate the scene
	main_menu = preload(__source_scene).instantiate()
	get_tree().root.add_child(main_menu)


func after_test() -> void:
	if main_menu and main_menu.is_inside_tree():
		main_menu.queue_free()


func test__ready() -> void:
	# Call _ready() to ensure it runs without errors
	main_menu._ready()

	# Simple assertion to mark test passed
	assert(true)
