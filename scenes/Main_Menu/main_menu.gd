class_name MainMenu
extends Control

@export var start_button: Button
@export var exit_button: Button
@onready var chess_two_player = preload("res://scenes/board/board.tscn") as PackedScene


func _ready():
	print(start_button)
	start_button.button_down.connect(on_start_pressed)
	exit_button.button_down.connect(on_exit_pressed)


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(chess_two_player)


func on_exit_pressed() -> void:
	get_tree().quit()
