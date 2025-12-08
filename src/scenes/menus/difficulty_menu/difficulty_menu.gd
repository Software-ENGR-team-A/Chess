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
const RIFLEMAN_SCRIPT := preload("res://scenes/piece/Rifleman.gd")

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
	0b0000111111110000,
	0b0001111111111000,
	0b0001110110111000,
	0b0001111111111000,
	0b0001111111111000,
	0b0001110110111000,
	0b0001111111111000,
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
	{"script": RIFLEMAN_SCRIPT, "pos": Vector2i(-4, -4), "player": 0},
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
	{"script": RIFLEMAN_SCRIPT, "pos": Vector2i(3, 3), "player": 1}
]

var difficulty := 1


func _ready() -> void:
	$TextureRect/HBoxContainer/EasyButton.pressed.connect(func(): set_difficulty(0))
	$TextureRect/HBoxContainer/MediumButton.pressed.connect(func(): set_difficulty(1))
	$TextureRect/HBoxContainer/HardButton.pressed.connect(func(): set_difficulty(2))

	$TextureRect/VBoxContainer/StartButton.pressed.connect(start_game)


func set_difficulty(value: int):
	difficulty = value


func start_game() -> void:
	MusicManager.stop_music()
	await get_tree().create_timer(.5).timeout

	var new_board = BOARD_SCENE.instantiate()
	new_board.set_difficulty(difficulty)

	var squares
	var pieces

	if difficulty == 0:
		squares = default_squares
		pieces = BOARD_PIECES_SCRIPT.generate_pieces_from_data(default_pieces_data)
	elif difficulty == 1:
		squares = medium_squares
		pieces = BOARD_PIECES_SCRIPT.generate_pieces_from_data(default_pieces_data)
	else:
		squares = master_squares
		pieces = BOARD_PIECES_SCRIPT.generate_pieces_from_data(master_pieces_data)

	new_board.setup(true, squares, pieces)
	get_tree().root.add_child(new_board)
	queue_free()
