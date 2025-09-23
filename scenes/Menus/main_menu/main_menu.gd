class_name MainMenu
extends Control

const BOARD_SCENE := preload("res://scenes/board/board.tscn")
const BOARD_PIECES_SCRIPT := preload("res://scenes/board/board_pieces.gd")
const AUDIO_BUS := preload("res://scenes/sound_system/default_bus_layout.tres")

# Load all piece classes to prevent null pointers
const PAWN_SCRIPT := preload("res://scenes/piece/Pawn.gd")
const ROOK_SCRIPT := preload("res://scenes/piece/Rook.gd")
const KNIGHT_SCRIPT := preload("res://scenes/piece/Knight.gd")
const BISHOP_SCRIPT := preload("res://scenes/piece/Bishop.gd")
const QUEEN_SCRIPT := preload("res://scenes/piece/Queen.gd")
const KING_SCRIPT := preload("res://scenes/piece/King.gd")

const RIFLEMAN_SCRIPT := preload("res://scenes/piece/Rifleman.gd")

@export var start_button: Button
@export var option_button: Button
@export var exit_button: Button

var default_squares := [
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000
]

var default_pieces_data := [
	# White Front Row
	{"script": PAWN_SCRIPT, "pos": Vector2i(-4, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-3, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-2, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-1, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(0, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(1, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(2, -3), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(3, -3), "player": 0},
	# White Back Row
	{"script": ROOK_SCRIPT, "pos": Vector2i(-4, -4), "player": 0},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(-3, -4), "player": 0},
	{"script": BISHOP_SCRIPT, "pos": Vector2i(-2, -4), "player": 0},
	{"script": KING_SCRIPT, "pos": Vector2i(-1, -4), "player": 0},
	{"script": QUEEN_SCRIPT, "pos": Vector2i(0, -4), "player": 0},
	{"script": BISHOP_SCRIPT, "pos": Vector2i(1, -4), "player": 0},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(2, -4), "player": 0},
	{"script": RIFLEMAN_SCRIPT, "pos": Vector2i(3, -4), "player": 0},
	# Black Front Row
	{"script": PAWN_SCRIPT, "pos": Vector2i(-4, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-3, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-2, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-1, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(0, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(1, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(2, 2), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(3, 2), "player": 1},
	# Black Back Row
	{"script": RIFLEMAN_SCRIPT, "pos": Vector2i(-4, 3), "player": 1},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(-3, 3), "player": 1},
	{"script": BISHOP_SCRIPT, "pos": Vector2i(-2, 3), "player": 1},
	{"script": KING_SCRIPT, "pos": Vector2i(-1, 3), "player": 1},
	{"script": QUEEN_SCRIPT, "pos": Vector2i(0, 3), "player": 1},
	{"script": BISHOP_SCRIPT, "pos": Vector2i(1, 3), "player": 1},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(2, 3), "player": 1},
	{"script": ROOK_SCRIPT, "pos": Vector2i(3, 3), "player": 1}
]


func _ready():
	get_window().size = DisplayServer.screen_get_size()
	MusicManager.play_random_song()
	MusicManager.set_volume(2)
	start_button.button_down.connect(on_start_pressed)
	option_button.button_down.connect(on_option_pressed)
	exit_button.button_down.connect(on_exit_pressed)


func on_start_pressed() -> void:
	MusicManager.stop_music()
	await get_tree().create_timer(.5).timeout

	var new_board = BOARD_SCENE.instantiate()
	var new_pieces = BOARD_PIECES_SCRIPT.generate_pieces_from_data(default_pieces_data)
	new_board.setup(true, default_squares, new_pieces)
	get_tree().root.add_child(new_board)
	queue_free()


func on_option_pressed() -> void:
	pass


func on_exit_pressed() -> void:
	get_tree().quit()
