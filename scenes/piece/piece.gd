class_name Piece
extends Node2D

enum MovementOutcome { BLOCKED, AVAILABLE, CAPTURE }
enum DebugTimelineModes { NONE, LOSSES, ALL }

const DEBUG_TIMELINE_MODE := DebugTimelineModes.NONE

@export var player := 0  # Black vs White
@export var board_pos: Vector2i
@export var original_pos: Vector2i
@export var sprite_index := 0  # Where in the sprite sheet it exists
@export var previous_position: Vector2i
@export var forward_direction: int
@export var point_value := 0  # The point value for the engine

var board: Board  # Parent board node

var checked_cells: Dictionary
var checked_cells_half_move: int

var last_moved_half_move := 0


func _ready() -> void:
	self.set_sprite(sprite_index)
	set_sprite(sprite_index)


## Sets all the root information for a piece.
## [param board]: The [Board] that owns the piece
## [param pos]: Starting position of the piece
## [param player]: Owner of the piece
func setup(board: Board, pos: Vector2i, player: int) -> void:
	self.board = board
	set_board_pos(pos)
	original_pos = board_pos
	self.player = player
	forward_direction = -1 if player else 1


## Sets the sprite of the piece based on the owning player. White pieces get the n'th [param sprite]
## within the top half of the spritesheet, while black sprites get them from the lower half.
func set_sprite(sprite: int) -> void:
	sprite_index = sprite
	$Sprite.frame = sprite_index + player * 32
	if has_node("Shadow"):
		$Shadow.frame = sprite_index + player * 32


## Moves the piece to the specified [param pos]. Movements must be checked for validity *before*
## calling this. If [param pos] contains a piece before moving, it is automatically captured.
## Additional movement actions will be triggered automatically.
func move_to(pos: Vector2i) -> void:
	# Pick up original piece
	board.piece_map.set(board_pos, null)

	# Capture
	var replaced_piece = board.get_piece_at(pos)
	if replaced_piece:
		replaced_piece.capture()

	# Perform extra actions
	movement_actions(pos)

	# Move piece
	previous_position = board_pos
	set_board_pos(pos)
	last_moved_half_move = board.half_moves
	board.piece_map[pos] = self


## Changes the visual and saved [member board_pos] to [param pos]
func set_board_pos(pos: Vector2i) -> void:
	board_pos = pos
	set_position(Vector2((pos.x + 1) * 16 - 8, (pos.y) * 16 + 4))


## Removes the piece from its parent [Board] and removes self from memory
func capture() -> void:
	if board.get_piece_at(board_pos) == self:
		board.piece_map.set(board_pos, null)
		board.pieces.remove_child(self)

		if board.is_og():
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
			if board.has_floor_at(map_cell):
				if movement_outcome_at(map_cell) == MovementOutcome.AVAILABLE:
					return true
	return false


## Determines if the piece can legally move to [param pos] based on movement rules and board state.
func movement_outcome_at(pos: Vector2i) -> MovementOutcome:
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
	var move_outcome = _movement(pos)

	# If still valid, check the future to see if the move puts the player into check
	if move_outcome != MovementOutcome.BLOCKED and board.is_og():
		var new_timeline: Board = board.branch()
		var show_debug_window = DEBUG_TIMELINE_MODE == DebugTimelineModes.ALL

		var timeline_piece: Piece = new_timeline.get_piece_at(board_pos)
		timeline_piece.move_to(pos)
		new_timeline.half_moves += 1

		var king_to_consider: King = new_timeline.white_king if player else new_timeline.black_king
		var check_piece = king_to_consider.in_check()
		if check_piece:
			if DEBUG_TIMELINE_MODE == DebugTimelineModes.LOSSES:
				show_debug_window = true

			move_outcome = MovementOutcome.BLOCKED
			new_timeline.color_board_squares(check_piece)

		# Debugging
		if show_debug_window:
			board.show_debug_timeline(new_timeline)
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
	return movement_outcome_at(pos + direction_to_piece) == MovementOutcome.AVAILABLE


## The internal piece movement method. Should probably only be used in conjunction with
## [method movement_outcome_at]. This does *not* take in mind moves that are invalid as a result
## of check / checkmate rules. For instance, movement for a pinned piece may return
## [code]AVAILABLE[/code], where [method can_move_to] would detect this and return
## [code]BLOCKED[/code]
##[param _pos]: Position to check for a movement outcome
func _movement(_pos: Vector2i) -> MovementOutcome:
	return MovementOutcome.BLOCKED


## Additional actions to perform when moving to [param _pos]. Note that capture of an existing piece
## at [param _pos] is implied and performed automatically on movement, as directed in
## [method move_to]
func movement_actions(_pos: Vector2i) -> void:
	pass


## Sets the visibility of the piece's shadow
##[param on]: Should the shadow be turned on or off? Default on.
func show_shadow(on: bool = true) -> void:
	if has_node("Shadow"):
		if on:
			var shadow = $Shadow
			shadow.visible = true
			shadow.texture = $Sprite.texture
			shadow.region_enabled = $Sprite.region_enabled
			shadow.region_rect = $Sprite.region_rect
		else:
			$Shadow.visible = false
