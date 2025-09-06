class_name Piece
extends Node2D

enum MovementOutcome { BLOCKED, AVAILABLE, CAPTURE }

@export var player := 0  # Black vs White
@export var board_pos: Vector2i
@export var original_pos: Vector2i

var sprite_index := 0  # Where in the sprite sheet it exists
var point_value := 0  # The point value for the engine
var board: Board
var checked_cells: Dictionary
var checked_cells_half_move: int


func _ready() -> void:
	self.set_sprite(get_sprite_index())
	set_sprite(sprite_index)


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.board = board
	set_board_pos(pos)
	original_pos = board_pos
	self.player = player


func set_sprite(sprite: int) -> void:
	sprite_index = sprite
	$Sprite.frame = sprite_index + player * 32


func set_board_pos(pos: Vector2i) -> void:
	board_pos = pos
	set_position(Vector2((pos.x + 1) * 16 - 8, (pos.y) * 16 + 4))


func get_board_pos() -> Vector2i:
	return board_pos


func get_sprite_index() -> int:
	return sprite_index


func can_move_to(pos: Vector2i) -> MovementOutcome:
	# Can't move to itself or to somewhere without floor
	if pos == board_pos or not board.has_floor_at(pos):
		return MovementOutcome.BLOCKED

	# Reset saved cells if move changed
	if board.half_moves != checked_cells_half_move:
		checked_cells = {}
		checked_cells_half_move = board.half_moves

	# Check previously generated moves
	var saved_move = checked_cells.get(pos, null)
	if saved_move != null:
		return saved_move

	# Check script
	var can_move = _movement(pos)
	checked_cells.set(pos, can_move)
	return can_move


func _movement(_pos: Vector2i) -> MovementOutcome:
	return MovementOutcome.BLOCKED
