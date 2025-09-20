class_name BoardSquares
extends TileMapLayer

# Sprite Indices
const TILESET_ID := 0
const WHITE_TILE := Vector2i(0, 3)
const BLACK_TILE := Vector2i(0, 7)
const CYAN_TILE := Vector2i(1, 3)
const DARK_CYAN_TILE := Vector2i(1, 7)
const GREEN_TILE := Vector2i(2, 3)
const DARK_GREEN_TILE := Vector2i(2, 7)
const PURPLE_TILE := Vector2i(3, 3)
const DARK_PURPLE_TILE := Vector2i(3, 7)
const ORANGE_TILE := Vector2i(4, 3)
const DARK_ORANGE_TILE := Vector2i(4, 7)
const RED_TILE := Vector2i(5, 3)
const DARK_RED_TILE := Vector2i(5, 7)

## The [Board] the squares are associated with
var board: Board

## An array of length 16 comprised of 16 bit uints, representing the
## presence or absence of a floor tile in a grid
var floor_data := []

## The previous known location the cursor was hovering, to allow for easy resetting to normal
var last_tile_highlighted: Vector2i


## Sets all the root information for board squares
## [param board]: Value to set [member board] to
## [param floor_data]: Value to set [member floor_data] to
func setup(board, floor_data) -> void:
	self.board = board
	self.floor_data = floor_data
	if board.is_primary:
		self.recolor(null)


## Returns [code]true[/true] if the [param pos] is a valid square that pieces can be on,
## as opposed to a hole.
func has_floor_at(pos: Vector2i) -> bool:
	if pos.x < -8 or pos.x > 8:
		return false
	return get_bit(floor_data[pos.y - 8], 16 - pos.x - 8 - 1)


## Adds or removes floor on the board
## [param pos]: The tile to change
## [param on]: Whether to enable or disable the tile
func set_at(pos: Vector2i, on: bool) -> void:
	if pos.clampi(-8, 7) != pos:
		return

	var has_floor := has_floor_at(pos)
	var to_add := 1 << (16 - pos.x - 8 - 1)

	if has_floor and not on:
		to_add = -1 * to_add
	elif not (has_floor and on):
		return

	floor_data[pos.y - 8] += to_add
	return


## Re-calculates all the tiles. If supplied a [param selected_piece], the floor will indicate
##valid movement options for that piece.
func recolor(selected_piece: Piece) -> void:
	# Load Squares
	for col in range(0, 16):
		for row in range(0, 16):
			var map_cell = Vector2i(row - 8, col - 8)
			if has_floor_at(map_cell):
				var tiles = calculate_square_tile_at(map_cell, selected_piece)
				set_cell(map_cell, TILESET_ID, tiles.light if (row + col) % 2 == 0 else tiles.dark)
			elif get_cell_tile_data(map_cell):
				erase_cell(map_cell)


## Returns what tiles should be used for a given [param map_cell], indicating valid movement options
## for an optional [param selected_piece]. Output format is a dictionary of the form
## [code]{"light": LIGHT_TILE, "dark": DARK_TILE}[/code]
func calculate_square_tile_at(map_cell: Vector2i, selected_piece: Piece) -> Dictionary:
	var piece_at_cell = board.pieces.at(map_cell)
	if piece_at_cell is King:
		if piece_at_cell.in_check():
			return {"light": ORANGE_TILE, "dark": DARK_ORANGE_TILE}

	if selected_piece:
		if selected_piece.board_pos == map_cell:
			return {"light": CYAN_TILE, "dark": DARK_CYAN_TILE}

		var outcome = selected_piece.movement_outcome_at(map_cell)

		if outcome == Piece.MovementOutcome.AVAILABLE:
			return {"light": GREEN_TILE, "dark": DARK_GREEN_TILE}

		if outcome == Piece.MovementOutcome.CAPTURE:
			return {"light": RED_TILE, "dark": DARK_RED_TILE}

	return {"light": WHITE_TILE, "dark": BLACK_TILE}


## Set the last_tile_highlighted to its default colour and color [param pos] blue
func set_highlight(pos) -> void:
	# Reset previous tile
	if pos != last_tile_highlighted and last_tile_highlighted != null:
		if get_cell_atlas_coords(last_tile_highlighted) == CYAN_TILE:
			set_cell(last_tile_highlighted, TILESET_ID, WHITE_TILE)
		elif get_cell_atlas_coords(last_tile_highlighted) == DARK_CYAN_TILE:
			set_cell(last_tile_highlighted, TILESET_ID, BLACK_TILE)

	# Set current tile
	if get_cell_atlas_coords(pos) == WHITE_TILE:
		set_cell(pos, TILESET_ID, CYAN_TILE)
		last_tile_highlighted = pos
	elif get_cell_atlas_coords(pos) == BLACK_TILE:
		set_cell(pos, TILESET_ID, DARK_CYAN_TILE)
		last_tile_highlighted = pos


## General utility method. Gets the bit in the [param pos] position in a [param bitfield]
static func get_bit(bitfield: int, pos: int) -> int:
	return (bitfield >> pos) & 1
