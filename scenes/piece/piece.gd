class_name Piece
extends Node2D

enum MovementOutcome { BLOCKED, AVAILABLE, CAPTURE }

@export var player := 0  # Black vs White
@export var board_pos: Vector2i
@export var original_pos: Vector2i

var sprite_index := 0  # Where in the sprite sheet it exists
var point_value := 0  # The point value for the engine
var board: Board
var previous_position: Vector2i
var forward_direction: int

var checked_cells: Dictionary
var checked_cells_half_move: int

var last_moved_half_move := 0


func _ready() -> void:
	self.set_sprite(get_sprite_index())
	set_sprite(sprite_index)


func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.board = board
	set_board_pos(pos)
	original_pos = board_pos
	self.player = player
	forward_direction = -1 if player else 1


func set_sprite(sprite: int) -> void:
	sprite_index = sprite
	$Sprite.frame = sprite_index + player * 32


func set_board_pos(pos: Vector2i) -> void:
	board_pos = pos
	set_position(Vector2((pos.x + 1) * 16 - 8, (pos.y) * 16 + 4))


func get_sprite_index() -> int:
	return sprite_index


func capture() -> void:
	if board.get_piece_at(board_pos) == self:
		board.piece_map.set(board_pos, null)
		if self.is_class("King"):
			AudioManager.play_sound(AudioManager.movement.checkmate)
		else:
			AudioManager.play_sound(AudioManager.movement.capture)
	queue_free()


## There is a big difference between using this function and
## using can_move_to on pieces with a recursive search.
##
## can_move_to in recursive pieces is designed to store the
## outcome of previous moves calculated in order to check if
## the current one is valid, whereas this is a one-off.
##
## The distinction might be worth reconsidering later, but this
## is fine for now.
func look_in_direction(dir: Vector2i, repeat: int) -> Piece:
	return board.look_in_direction(board_pos, dir, repeat)


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


func movement_actions(_pos: Vector2i) -> void:
	pass
