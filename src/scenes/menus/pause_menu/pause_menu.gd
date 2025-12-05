extends Control

@onready var board = $"../"


func _on_resume_pressed() -> void:
	board.pause()


func _on_quit_pressed() -> void:
	get_tree().quit()
