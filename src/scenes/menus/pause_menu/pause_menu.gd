extends Control

const MAIN_SCENE := preload("res://scenes/menus/main_menu/main_menu.tscn")

@onready var board = $"../"


func _on_resume_pressed() -> void:
	AudioManager.play_sound(AudioManager.menu.select)
	board.pause()


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main_menu/main_menu.tscn")
	AudioManager.play_sound(AudioManager.menu.select)
	board.queue_free()


func _on_quit_pressed() -> void:
	AudioManager.play_sound(AudioManager.menu.select)
	get_tree().quit()
