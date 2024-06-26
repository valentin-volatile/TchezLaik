extends Node2D
class_name Grid

signal tile_clicked(tile: Tile)
signal piece_clicked(piece: Piece)

@export var debug_info: bool = false
@export var rows: int = 5
@export var columns: int = 5
@export var override_scale: Vector2

@export_group("Tile Settings", "tile_")
@export var tile_scene: PackedScene
@export var tile_texture: Texture2D
#@export var bg_texture: Texture2D
@export var bg_colour: Color
@export var bg_margin: int
@export var highlight_amount: float = 0.140

@onready var pieces = $Pieces
@onready var tiles = $Tiles
@onready var grid_guide = $GridGuide

var highlight_colour := Color(highlight_amount, highlight_amount, highlight_amount, 0)
var grid_matrix: Array
# matrix that contains an array per position (with yet another array lol)
# [][][0] = tile (base or custom)
# [][][1] = piece (or null)


func _ready():
	grid_guide.visible = false
	set_up_global_vars()
	set_up_grid_bg()
	generate_grid()
	set_up_tiles()
	set_up_pieces()
	center()
	
	update_pieces()


func generate_grid() -> void:
# initializate array
	grid_matrix.resize(rows)
#DO NOT FILL WITH ARRAYS, they will all share a single reference
	grid_matrix.fill(0)
	for i in rows:
		grid_matrix[i] = []
		grid_matrix[i].resize(columns)
		for j in columns:
			grid_matrix[i][j] = []
			grid_matrix[i][j].resize(2)
		
	for row in rows:
		for column in columns:
			var tile: Tile = tile_scene.instantiate()
			add_child(tile)
			tile.sprite.texture = tile_texture
			tile.update_colour("white" if ((row + column -2)%2) else "black")
			tile.position = Vector2(Global.TILE_SIZE*column, Global.TILE_SIZE*row)
			tile.show_debug_info(debug_info)
			
			grid_matrix[row][column][0] = tile
			tile.was_clicked.connect(on_tile_click)


func set_up_tiles() -> void:
	var tile_array = tiles.get_children()
	
	for tile in tile_array:
		var pos = tile.position
		tile.was_clicked.connect(on_tile_click)
		if not tile.sprite.texture: tile.sprite.texture = tile_texture
		tile.update_colour(grid_matrix[pos.y/Global.TILE_SIZE][pos.x/Global.TILE_SIZE][0].colour)
		grid_matrix[pos.y/Global.TILE_SIZE][pos.x/Global.TILE_SIZE][0].queue_free()
		grid_matrix[pos.y/Global.TILE_SIZE][pos.x/Global.TILE_SIZE][0] = tile


func set_up_pieces() -> void:
	var piece_array = pieces.get_children()
	
	for piece in piece_array:
		var pos = piece.position
		grid_matrix[pos.y/Global.TILE_SIZE][pos.x/Global.TILE_SIZE][1] = piece
		piece.was_clicked.connect(on_piece_click)
		Global.pieces.append(piece)


func set_up_grid_bg() -> void:
	#when using texture
	#var bg := TextureRect.new()
	#bg.texture = bg_texture
	#bg.modulate = bg_colour
	#bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	var bg := ColorRect.new()
	bg.color = bg_colour
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE # necesario?
	bg.size.x = (Global.TILE_SIZE*columns)+bg_margin
	bg.size.y = (Global.TILE_SIZE*rows)+bg_margin
# center
	bg.position -= Vector2(bg_margin/2.0, bg_margin/2.0)
	add_child(bg)


func set_up_global_vars() -> void:
	Global.grid_matrix = grid_matrix
	Global.grid_rows = rows
	Global.grid_columns = columns


func update_pieces() -> void:
	for piece in pieces.get_children():
		piece.update_valid_tiles()


func center() -> void:
	global_position = Vector2(-(Global.TILE_SIZE*columns)/2.0, -(Global.TILE_SIZE*rows)/2.0)


func on_tile_click(tile: Tile) -> void:
	tile_clicked.emit(tile)


func on_piece_click(piece: Piece) -> void:
	piece_clicked.emit(piece)
