class_name MainMenu
extends Control

const BOARD_SCENE := preload("res://scenes/board/board.tscn")
const BOARD_PIECES_SCRIPT := preload("res://scenes/board/board_pieces.gd")
const AUDIO_BUS := preload("res://scenes/sound_system/default_bus_layout.tres")
const OPTIONS_SCENE := preload("res://scenes/menus/options_menu/options_menu.tscn")

# Load all piece classes to prevent null pointers
const PAWN_SCRIPT := preload("res://scenes/piece/pawn.gd")
const ROOK_SCRIPT := preload("res://scenes/piece/rook.gd")
const KNIGHT_SCRIPT := preload("res://scenes/piece/knight.gd")
const BISHOP_SCRIPT := preload("res://scenes/piece/bishop.gd")
const QUEEN_SCRIPT := preload("res://scenes/piece/queen.gd")
const KING_SCRIPT := preload("res://scenes/piece/king.gd")

const RIFLEMAN_SCRIPT := preload("res://scenes/piece/Rifleman.gd")

@export var start_button: Button
@export var option_button: Button
@export var exit_button: Button


func _ready():
	get_window().size = DisplayServer.screen_get_size()
	MusicManager.play_random_song()
	MusicManager.set_volume(-15)
	start_button.button_down.connect(on_start_pressed)
	option_button.button_down.connect(on_option_pressed)
	exit_button.button_down.connect(on_exit_pressed)


func on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/difficulty_menu/difficulty_menu.tscn")


func on_option_pressed() -> void:
	var options = OPTIONS_SCENE.instantiate()
	get_tree().root.add_child(options)


func on_exit_pressed() -> void:
	get_tree().quit()
