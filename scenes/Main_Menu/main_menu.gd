class_name MainMenu
extends Control

@export var start_button: Button
@export var exit_button: Button
@export var yes_button: Button
@export var no_button: Button
@onready var chess_two_player = preload("res://scenes/board/board.tscn") as PackedScene


func _ready():
	MusicManager.play_random_song()
	MusicManager.set_volume(1)
	print(start_button)
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)
	yes_button.button_down.connect(on_yes_pressed)
	no_button.button_down.connect(on_no_pressed)


func on_start_pressed() -> void:
	MusicManager.stop_music()
	AudioManager.play_selectmenu()
	await get_tree().create_timer(.5).timeout
	get_tree().change_scene_to_packed(chess_two_player)


func on_exit_pressed() -> void:
	%Conformation_Box.popup()


func on_yes_pressed() -> void:
	get_tree().quit()


func on_no_pressed() -> void:
	%Conformation_Box.hide()
