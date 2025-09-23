class_name Piece
extends Node2D

enum MovementOutcome { BLOCKED, AVAILABLE, CAPTURE, AVAILABLE_BAD_FOR_KING, CAPTURE_BAD_FOR_KING }
enum DebugTimelineModes { NONE, LOSSES, ALL }

const DEBUG_TIMELINE_MODE := DebugTimelineModes.NONE

# @xport is used for properties that need to persist after running [method branch].

@export var player := 0  # Black vs White
@export var board_pos: Vector2i
@export var original_pos: Vector2i
@export var anim_name := ""
@export var previous_position: Vector2i
@export var point_value := 0  # The point value for the engine

## The [Board] the squares are associated with
var board: Board

## Dictionary of the pattern [code]{ Vector2i: MovementOutcome }[\code], storing the output of
## [method movement_outcome_at] valid for the current [member checked_cells_half_move]
var checked_cells: Dictionary

## The [member Board.half_move] that the [member checked_cells] dictionary is valid for
var checked_cells_half_move: int

## Last time piece moved, measured by [member Board.half_moves]
var last_moved_half_move := 0

@onready var internal_offset = %InternalOffset
@onready var sprite_rot = %SpriteRot
@onready var shadow_rot = %ShadowRot
@onready var sprite = %Sprite
@onready var shadow = %Shadow


## Sets all the root information for a piece.
## [param board]: The [Board] that owns the piece
## [param pos]: Starting position of the piece
## [param player]: Owner of the piece
func setup(_board: Board, _pos: Vector2i, _player: int) -> void:
	board = _board
	set_board_pos(_pos)
	original_pos = board_pos
	player = player


func _ready() -> void:
	%Sprite.animation = anim_name
	%Shadow.animation = anim_name


func get_player_name() -> String:
	return "Black" if player else "White"


## Returns a duplicate of the piece
func branch() -> Piece:
	var new_piece = duplicate()
	return new_piece


## Moves the piece to the specified [param pos]. Movements must be checked for validity *before*
## calling this. Captures from member [method captures_when_moved_to] and additional movement
## actions will be triggered automatically.
func move_to(pos: Vector2i) -> void:
	# Pick up original piece
	board.pieces.map.set(board_pos, null)

	# Captures
	for piece in captures_when_moved_to(pos):
		piece.capture()

	# Perform extra actions
	movement_actions(pos)

	# Move piece
	previous_position = board_pos
	set_board_pos(pos)
	last_moved_half_move = board.half_moves
	board.pieces.map[pos] = self


## Changes the visual and saved [member board_pos] to [param pos]
func set_board_pos(pos: Vector2i) -> void:
	board_pos = pos
	set_position(Vector2((pos.x + 1) * 16 - 8, (pos.y) * 16 - 4))


## Removes the piece from its parent [Board] and removes self from memory
func capture() -> void:
	if board.pieces.at(board_pos) == self:
		board.pieces.map.set(board_pos, null)
		board.pieces.remove_child(self)

		if board.is_primary:
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


## Returns the first [Piece] seen in [param repeat] iterations of checking
## the [param offset] from the piece. If no piece is found, returns [code]null[/code]
##
## Note: this distinct from [method has_line_of_movement_to]
func look_in_direction(offset: Vector2i, repeat: int) -> Piece:
	return board.look_in_direction(board_pos, offset, repeat)


## Returns if any possible moves are available for the piece
func has_valid_moves() -> bool:
	for row in range(0, 16):
		for col in range(0, 16):
			var map_cell = Vector2i(col - 8, row - 8)
			if board.squares.has_floor_at(map_cell):
				if movement_safe_for_king(movement_outcome_at(map_cell)):
					return true
	return false


## Determines if the piece can legally move to [param pos] based on movement rules and board state.
func movement_outcome_at(pos: Vector2i) -> MovementOutcome:
	# Can't move to itself or to somewhere without floor
	if pos == board_pos or not board.squares.has_floor_at(pos):
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
	var move_outcome = _movement(pos)

	# If still valid, check the future to see if the move puts the player into check
	if move_outcome != MovementOutcome.BLOCKED and board.is_primary:
		var new_timeline: Board = board.branch()
		var show_debug_window = DEBUG_TIMELINE_MODE == DebugTimelineModes.ALL

		var timeline_piece: Piece = new_timeline.pieces.at(board_pos)
		timeline_piece.move_to(pos)
		new_timeline.half_moves += 1

		var king_to_consider: King = (
			new_timeline.pieces.white_king if player else new_timeline.pieces.black_king
		)
		var check_piece = king_to_consider.in_check()
		if check_piece:
			if DEBUG_TIMELINE_MODE == DebugTimelineModes.LOSSES:
				show_debug_window = true

			if move_outcome == MovementOutcome.AVAILABLE:
				move_outcome = MovementOutcome.AVAILABLE_BAD_FOR_KING
			elif move_outcome == MovementOutcome.CAPTURE:
				move_outcome = MovementOutcome.CAPTURE_BAD_FOR_KING

		# Debugging
		if show_debug_window:
			board.show_debug_timeline(new_timeline)
			if check_piece:
				new_timeline.squares.recolor(check_piece)
			else:
				new_timeline.squares.recolor(null)
		else:
			new_timeline.queue_free()

	checked_cells.set(pos, move_outcome)
	return move_outcome


## Calculates if every square between [param pos] and the piece are open squares, and returns
## [code]true[/code] if they're all free. Only works on cardinal or intercardinal directions.
## Dependent moves are calculated and saved in checked_cells for future movement checks.
##
## Note: this distinct from [method look_in_direction]
func has_line_of_movement_to(pos: Vector2i) -> bool:
	# Can always move to immediately touching
	if board_pos.distance_to(pos) < 1.5:
		return true

	# Check if dependent movement is valid
	var direction_to_piece = (board_pos - pos).sign()
	return movement_available(movement_outcome_at(pos + direction_to_piece))


## The internal piece movement method. Should probably only be used in conjunction with
## [method movement_outcome_at]. This does *not* take in mind moves that are invalid as a result
## of check / checkmate rules. For instance, movement for a pinned piece may return
## [code]AVAILABLE[/code], where [method can_move_to] would detect this and return
## [code]BLOCKED[/code]
##[param _pos]: Position to check for a movement outcome
func _movement(_pos: Vector2i) -> MovementOutcome:
	return MovementOutcome.BLOCKED


## Returns the pieces to be captured when moved to [param pos].
func captures_when_moved_to(pos: Vector2i) -> Array[Piece]:
	var output: Array[Piece] = []

	var piece_to_crush = board.pieces.at(pos)
	if piece_to_crush:
		output.push_back(piece_to_crush)

	return output


## Additional actions to perform when moving to [param _pos]. Note that capture of an existing piece
## at [param _pos] is implied and performed automatically on movement, as directed in
## [method move_to]
func movement_actions(_pos: Vector2i) -> void:
	pass


## Sets the visibility of the piece's shadow
##[param on]: Should the shadow be turned on or off? Default on.
func picked_up(on: bool = true) -> void:
	%Shadow.visible = on
	if on:
		%Sprite.play()
		%Shadow.play()
	else:
		%Sprite.stop()
		%Shadow.stop()


## Checks if [param outcome] does not put the king in danger
static func movement_safe_for_king(outcome: MovementOutcome) -> bool:
	return outcome == MovementOutcome.AVAILABLE or outcome == MovementOutcome.CAPTURE


## Checks if [param outcome] is available, whether or not it puts the king in danger
static func movement_available(outcome: MovementOutcome) -> bool:
	return outcome == MovementOutcome.AVAILABLE or outcome == MovementOutcome.AVAILABLE_BAD_FOR_KING
