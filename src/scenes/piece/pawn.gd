class_name Pawn
extends Piece

var forward_direction: int


func setup(_board: Board, _pos: Vector2i, _player: int) -> void:
	super.setup(_board, _pos, _player)
	point_value = 1
	center_control_multiplier = 1.5
	anim_name = get_player_name() + "Pawn"
	forward_direction = -1 if player else 1


# Override move_to so we can special-case promotion
func move_to(pos: Vector2i) -> void:
	var is_promotion := (
		(forward_direction == -1 and pos.y == -4) or (forward_direction == 1 and pos.y == 3)
	)

	if not is_promotion:
		# Normal move: use base Piece logic
		super.move_to(pos)
		return

	# ---------- PROMOTION MOVE ----------

	# 1) Clear old square in board map
	board.pieces.map.set(board_pos, null)

	# 2) Handle captures (normal + en passant via captures_when_moved_to)
	for piece in captures_when_moved_to(pos):
		piece.capture()

	# 3) Run any extra pawn actions (like your en passant cleanup)
	#    This keeps behavior consistent with non-promotion moves.
	movement_actions(pos)

	# 4) Cache pawn data we want to carry over
	var pawn_board := board
	var pawn_player := player
	var pawn_original := original_pos
	var pawn_prev := board_pos

	# Make sure the piece is reset before duplicated and swapped
	board.pieces.pick_up(null)

	# 5) Create a new node by duplicating this pawn (keeps all child nodes intact)
	var queen := duplicate() as Piece

	# 6) Convert that duplicate into a Queen by swapping the script
	queen.set_script(load("res://scenes/piece/queen.gd"))

	# 7) Attach the queen node to the board
	pawn_board.pieces.add_child(queen)

	# 8) Initialize queen like a normal piece
	queen.board = pawn_board
	queen.player = pawn_player
	queen.original_pos = pawn_original
	queen.previous_position = pawn_prev
	queen.set_board_pos(pos)
	queen.last_moved_half_move = pawn_board.half_moves
	queen.point_value = 9
	queen.anim_name = get_player_name() + "Queen"

	# 9) Update animations in case Queen._ready doesn't handle this immediately
	if is_instance_valid(queen.sprite):
		queen.sprite.animation = queen.anim_name
	if is_instance_valid(queen.shadow):
		queen.shadow.animation = queen.anim_name

	# 10) Put queen into board map
	pawn_board.pieces.map[pos] = queen

	# 11) Remove the original pawn node
	pawn_board.pieces.remove_child(self)
	queue_free()


func _movement(pos: Vector2i) -> MovementOutcome:
	var piece_to_capture = board.pieces.at(pos)

	# Can't capture own piece
	if is_friendly(piece_to_capture):
		return MovementOutcome.BLOCKED

	# En passant is also an option
	if not piece_to_capture:
		piece_to_capture = get_en_passant_target(pos)

	if piece_to_capture:
		# Check diagonals
		if pos == board_pos + Vector2i(1, self.forward_direction):
			return MovementOutcome.CAPTURE
		if pos == board_pos + Vector2i(-1, self.forward_direction):
			return MovementOutcome.CAPTURE
	else:
		# Single square advance
		if pos == (board_pos + Vector2i(0, self.forward_direction)):
			return MovementOutcome.AVAILABLE

		# Check if double advanced is possible
		if (
			board_pos == original_pos
			and pos == (board_pos + Vector2i(0, 2 * self.forward_direction))
			and movement_outcome_at(board_pos + Vector2i(0, self.forward_direction))
		):
			return MovementOutcome.AVAILABLE

	return MovementOutcome.BLOCKED


func get_en_passant_target(pos: Vector2i) -> Pawn:
	var target = board.pieces.at(pos + Vector2i(0, -self.forward_direction))

	# Target must:
	if not target:
		# exist,
		return
	if not target is Pawn:
		# be a pawn,
		return
	if target.player == player:
		# be owned by the opposing team,
		return
	if not target.previous_position or target.last_moved_half_move != board.half_moves - 1:
		# have just moved,
		return
	if target.previous_position + Vector2i(0, 2 * target.forward_direction) != target.board_pos:
		# and have done a double-advance
		return

	return target


func movement_actions(pos: Vector2i) -> void:
	super.movement_actions(pos)

	var en_passant_target = get_en_passant_target(pos)
	if en_passant_target:
		en_passant_target.capture()


func captures_when_moved_to(pos: Vector2i) -> Array[Piece]:
	var captures = super.captures_when_moved_to(pos)
	var en_passant_target = get_en_passant_target(pos)
	if en_passant_target:
		captures.push_back(en_passant_target)
	return captures
