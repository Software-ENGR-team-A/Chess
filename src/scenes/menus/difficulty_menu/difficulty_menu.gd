class_name DifficultyMenu
extends Control

const BOARD_SCENE := preload("res://scenes/board/board.tscn")
const BOARD_PIECES_SCRIPT := preload("res://scenes/board/board_pieces.gd")

const PAWN_SCRIPT := preload("res://scenes/piece/pawn.gd")
const ROOK_SCRIPT := preload("res://scenes/piece/rook.gd")
const KNIGHT_SCRIPT := preload("res://scenes/piece/knight.gd")
const BISHOP_SCRIPT := preload("res://scenes/piece/bishop.gd")
const QUEEN_SCRIPT := preload("res://scenes/piece/queen.gd")
const KING_SCRIPT := preload("res://scenes/piece/king.gd")
const RIFLEMAN_SCRIPT := preload("res://scenes/piece/rifleman.gd")
const ROACH_SCRIPT := preload("res://scenes/piece/roach.gd")
const BUILDER_SCRIPT := preload("res://scenes/piece/builder.gd")

@export var easy_button: Button
@export var medium_button: Button
@export var hard_button: Button

@export var ai_button: Button
@export var local_button: Button

@export var start_button: Button

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

var medium_squares := [
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111001110000,
	0b0000111001110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000111111110000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000
]

var master_squares := [
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0000000000000000,
	0b0011111111110000,
	0b0010111111110000,
	0b0010110110110000,
	0b0010111111110100,
	0b0010111111110100,
	0b0000110110110100,
	0b0000111111110100,
	0b0000111111111100,
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
	{"script": ROOK_SCRIPT, "pos": Vector2i(3, -4), "player": 0},
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
	{"script": ROOK_SCRIPT, "pos": Vector2i(-4, 3), "player": 1},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(-3, 3), "player": 1},
	{"script": BISHOP_SCRIPT, "pos": Vector2i(-2, 3), "player": 1},
	{"script": KING_SCRIPT, "pos": Vector2i(-1, 3), "player": 1},
	{"script": QUEEN_SCRIPT, "pos": Vector2i(0, 3), "player": 1},
	{"script": BISHOP_SCRIPT, "pos": Vector2i(1, 3), "player": 1},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(2, 3), "player": 1},
	{"script": ROOK_SCRIPT, "pos": Vector2i(3, 3), "player": 1}
]

var medium_pieces_data := [
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
	{"script": BUILDER_SCRIPT, "pos": Vector2i(-4, -4), "player": 0},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(-3, -4), "player": 0},
	{"script": ROACH_SCRIPT, "pos": Vector2i(-2, -4), "player": 0},
	{"script": KING_SCRIPT, "pos": Vector2i(-1, -4), "player": 0},
	{"script": QUEEN_SCRIPT, "pos": Vector2i(0, -4), "player": 0},
	{"script": ROACH_SCRIPT, "pos": Vector2i(1, -4), "player": 0},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(2, -4), "player": 0},
	{"script": BUILDER_SCRIPT, "pos": Vector2i(3, -4), "player": 0},
	# Middle
	{"script": PAWN_SCRIPT, "pos": Vector2i(-2, -1), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(1, -1), "player": 1},
	{"script": PAWN_SCRIPT, "pos": Vector2i(-2, 0), "player": 0},
	{"script": PAWN_SCRIPT, "pos": Vector2i(1, 0), "player": 0},
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
	{"script": BUILDER_SCRIPT, "pos": Vector2i(-4, 3), "player": 1},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(-3, 3), "player": 1},
	{"script": ROACH_SCRIPT, "pos": Vector2i(-2, 3), "player": 1},
	{"script": KING_SCRIPT, "pos": Vector2i(-1, 3), "player": 1},
	{"script": QUEEN_SCRIPT, "pos": Vector2i(0, 3), "player": 1},
	{"script": ROACH_SCRIPT, "pos": Vector2i(1, 3), "player": 1},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(2, 3), "player": 1},
	{"script": BUILDER_SCRIPT, "pos": Vector2i(3, 3), "player": 1}
]

var master_pieces_data := [
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
	{"script": ROOK_SCRIPT, "pos": Vector2i(3, -4), "player": 0},
	# Riflemen
	{"script": RIFLEMAN_SCRIPT, "pos": Vector2i(-6, 0), "player": 0},
	{"script": RIFLEMAN_SCRIPT, "pos": Vector2i(5, -1), "player": 1},
	# Counter-Knights
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(-4, 0), "player": 1},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(3, -1), "player": 0},
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
	{"script": ROOK_SCRIPT, "pos": Vector2i(-4, 3), "player": 1},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(-3, 3), "player": 1},
	{"script": BISHOP_SCRIPT, "pos": Vector2i(-2, 3), "player": 1},
	{"script": KING_SCRIPT, "pos": Vector2i(-1, 3), "player": 1},
	{"script": QUEEN_SCRIPT, "pos": Vector2i(0, 3), "player": 1},
	{"script": BISHOP_SCRIPT, "pos": Vector2i(1, 3), "player": 1},
	{"script": KNIGHT_SCRIPT, "pos": Vector2i(2, 3), "player": 1},
	{"script": ROOK_SCRIPT, "pos": Vector2i(3, 3), "player": 1}
]

var difficulty := 1
var ai := true


func _ready() -> void:
	easy_button.pressed.connect(func(): set_difficulty(0))
	medium_button.pressed.connect(func(): set_difficulty(1))
	hard_button.pressed.connect(func(): set_difficulty(2))

	ai_button.pressed.connect(func(): set_ai(true))
	local_button.pressed.connect(func(): set_ai(false))

	start_button.pressed.connect(start_game)


func set_difficulty(value: int):
	difficulty = value

	easy_button.disabled = value == 0
	medium_button.disabled = value == 1
	hard_button.disabled = value == 2
	AudioManager.play_sound(AudioManager.menu.select)


func set_ai(value: bool):
	ai = value

	ai_button.disabled = value == true
	local_button.disabled = value == false
	AudioManager.play_sound(AudioManager.menu.select)


func start_game() -> void:
	MusicManager.stop_music()
	await get_tree().create_timer(.5).timeout

	var new_board = BOARD_SCENE.instantiate()
	new_board.set_difficulty(difficulty)
	new_board.ai_enabled = ai

	var squares
	var pieces

	if difficulty == 0:
		squares = default_squares
		pieces = BOARD_PIECES_SCRIPT.generate_pieces_from_data(default_pieces_data)
	elif difficulty == 1:
		squares = medium_squares
		pieces = BOARD_PIECES_SCRIPT.generate_pieces_from_data(medium_pieces_data)
	else:
		squares = master_squares
		pieces = BOARD_PIECES_SCRIPT.generate_pieces_from_data(master_pieces_data)

	new_board.setup(true, squares, pieces)
	get_tree().root.add_child(new_board)
	AudioManager.play_sound(AudioManager.menu.select)
	queue_free()
