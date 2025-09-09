class_name Piece
extends Node2D

enum MovementOutcome { BLOCKED, AVAILABLE, CAPTURE }

@export var player := 0  # Black vs White
@export var board_pos: Vector2i
@export var original_pos: Vector2i

var sprite_index := 0  # Where in the sprite sheet it exists
var point_value := 0  # The point value for the engine
var board: Board  # Parent board node
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

		if self is King:
			AudioManager.play_sound(AudioManager.movement.checkmate, -15)
		else:
			AudioManager.play_sound(AudioManager.movement.capture)

	queue_free()


## Returns [code]true[/code] if [param piece] is owned by the same player as the calling piece
func is_friendly(piece: Piece) -> bool:
	return piece and piece.player == player


## Returns [code]true[/code] if [param target] is horizontally in line with the calling piece
func is_horizontal(target: Vector2i) -> bool:
	return board_pos.y == target.y and board_pos != target


## Returns [code]true[/code] if [param target] is vertically in line with the calling piece
func is_vertical(target: Vector2i) -> bool:
	return board_pos.x == target.x and board_pos != target


## Returns [code]true[/code] if [param target] is diagonally in line with the calling piece
func is_diagonal(target: Vector2i) -> bool:
	return abs(board_pos.x - target.x) == abs(board_pos.y - target.y) and board_pos != target


## Returns the first [code]Piece[/code] seen in [param repeat] iterations of checking
## the [param offset] from the piece. If no piece is found, returns [code]null[/code]
##
## Note: this distinct from [code]has_line_of_movement_to[/code]
func look_in_direction(offset: Vector2i, repeat: int) -> Piece:
	return board.look_in_direction(board_pos, offset, repeat)


## Determines if the piece can legally move to [param pos] based on movement rules and board state.
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


## Calculates if every square between [param pos] and the piece are open squares, and returns
## [code]true[/code] if they're all free. Only works on cardinal or intercardinal directions.
## Dependent moves are calculated and saved in checked_cells for future movement checks.
##
## Note: this distinct from [code]look_in_direction[/code]
func has_line_of_movement_to(pos: Vector2i) -> bool:
	# Can always move to immediately touching
	if board_pos.distance_to(pos) < 1.5:
		return true

	# Check if dependent movement is valid
	var direction_to_piece = (board_pos - pos).sign()
	return can_move_to(pos + direction_to_piece) == MovementOutcome.AVAILABLE


func _movement(_pos: Vector2i) -> MovementOutcome:
	return MovementOutcome.BLOCKED


func movement_actions(_pos: Vector2i) -> void:
	pass
