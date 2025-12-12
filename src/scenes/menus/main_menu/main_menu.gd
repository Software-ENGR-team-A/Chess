class_name MainMenu
extends Control

const BOARD_SCENE := preload("res://scenes/board/board.tscn")
const BOARD_PIECES_SCRIPT := preload("res://scenes/board/board_pieces.gd")
const AUDIO_BUS := preload("res://scenes/sound_system/default_bus_layout.tres")
const OPTIONS_SCENE := preload("res://scenes/menus/options_menu/options_menu.tscn")

# Load all piece classes to prevent null pointers

@export var start_button: Button
@export var option_button: Button
@export var exit_button: Button


func _ready():
	get_window().size = DisplayServer.screen_get_size()
	MusicManager.play_random_song()
	MusicManager.set_volume(-15)
	AudioManager.set_volume(-15)
	start_button.button_down.connect(on_start_pressed)
	option_button.button_down.connect(on_option_pressed)
	exit_button.button_down.connect(on_exit_pressed)


func on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/difficulty_menu/difficulty_menu.tscn")
	AudioManager.play_sound(AudioManager.menu.select)


func on_option_pressed() -> void:
	var options = OPTIONS_SCENE.instantiate()
	AudioManager.play_sound(AudioManager.menu.select)
	get_tree().root.add_child(options)


func on_exit_pressed() -> void:
	AudioManager.play_sound(AudioManager.menu.select)
	get_tree().quit()
