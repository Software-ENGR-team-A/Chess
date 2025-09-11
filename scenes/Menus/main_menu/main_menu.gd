class_name MainMenu
extends Control

const AUDIO_BUS := preload("res://scenes/sound_system/default_bus_layout.tres")

@export var start_button: Button
@export var option_button: Button
@export var exit_button: Button
@onready var chess_two_player = preload("res://scenes/board/board.tscn") as PackedScene
#going to add a new scene for options


func _ready():
	get_window().size = DisplayServer.screen_get_size()
	MusicManager.play_random_song()
	MusicManager.set_volume(2)
	print(start_button)
	start_button.button_down.connect(on_start_pressed)
	option_button.button_down.connect(on_option_pressed)
	exit_button.button_down.connect(on_exit_pressed)


func on_start_pressed() -> void:
	MusicManager.stop_music()
	await get_tree().create_timer(.5).timeout
	get_tree().change_scene_to_packed(chess_two_player)


func on_option_pressed() -> void:
	pass


func on_exit_pressed() -> void:
	get_tree().quit()
