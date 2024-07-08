extends Node

signal grid_changed

const TILE_SIZE: int = 256

#var colours = {"black": Color(0.741, 0.318, 0.424), "white": Color(0.322, 0.498, 0.722)}
#var colours = {"black": Color(0.153, 0.153, 0.267, 1.0), "white": Color(0.984, 0.961, 0.937, 1.0)}

const TILE_COLOURS = {
	"white": Color8(250,250,250,255),
	"black": Color8(74,74,181,255)
#highlight moving
#highlight eating
}

const PIECE_COLOURS = {
	"white": {
		"light": Color8(233,198,175,255),
		"medium": Color8(172,157,147,255),
		"dark": Color8(145,124,111,255)}, 
	"black": {
		"light": Color8(128,128,128,255),
		"medium": Color8(51,51,51,255),
		"dark": Color8(0,0,0,255)}
		}

var pieces: Array

var grid_node: Grid
var grid_matrix: Array
var grid_rows:int
var grid_columns: int


func reset_vars() -> void:
	pieces = []
	grid_matrix = []
	grid_rows = 0
	grid_columns = 0
	grid_node = null


func get_pieces(colour: String = "") -> Array:
	if colour:
		return pieces.filter(func(piece): return piece.colour == colour)
	return pieces


func get_attacked_pos(piece: Piece) -> Array:
	var pieces = get_pieces()
	var attacked_pos = []
	
	# check for captures supossing this piece doesn't exist
	grid_matrix[piece.position.y/TILE_SIZE][piece.position.x/TILE_SIZE][1] = null
	
	for enemy_piece in pieces:
		if enemy_piece.colour == piece.colour: continue
		
		enemy_piece._update_valid_captures()
		attacked_pos += enemy_piece.checked_tiles
		attacked_pos += enemy_piece.capture_tiles
	
	# leave captures as they were
	grid_matrix[piece.position.y/TILE_SIZE][piece.position.x/TILE_SIZE][1] = piece

	for enemy_piece in pieces:
		if enemy_piece.colour == piece.colour: continue
		enemy_piece._update_valid_captures()
	
	return attacked_pos


func is_in_grid(pos: Vector2i) -> bool:
	var x: int = pos.x/TILE_SIZE
	var y: int = pos.y/TILE_SIZE
	
	if y < 0 or x < 0: return false
	if y >= grid_rows or x >= grid_columns: return false
	return true

func get_info_at_pos(pos: Vector2i):
	return grid_matrix[pos.y/TILE_SIZE][pos.x/TILE_SIZE]

func get_tile_at_pos(pos: Vector2i) -> Tile:
	return grid_matrix[pos.y/Global.TILE_SIZE][pos.x/Global.TILE_SIZE][0]

func get_piece_at_pos(pos: Vector2) -> Piece:
	return grid_matrix[pos.y/Global.TILE_SIZE][pos.x/Global.TILE_SIZE][1]

func modify_matrix_tile_at_pos(pos: Vector2i, tile: Tile) -> void:
	grid_matrix[pos.y/TILE_SIZE][pos.x/TILE_SIZE][0] = tile
	
func modify_matrix_piece_at_pos(pos: Vector2i, piece: Piece) -> void:
	grid_matrix[pos.y/TILE_SIZE][pos.x/TILE_SIZE][1] = piece

func emit_grid_changed() -> void:
	grid_changed.emit()
