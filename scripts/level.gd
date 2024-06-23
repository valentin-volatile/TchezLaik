extends Node2D
class_name Level

signal piece_eaten(piece: Piece)
signal finished

@export var objective_piece: Piece

@onready var background = $Background
@onready var ui = $LevelUI
@onready var grid: Grid = $Grid
@onready var pieces = $Grid/Pieces
@onready var camera = $Camera2D

#[y][x]
var grid_matrix: Array

var selected_piece: Piece = null
var can_play: bool = false #set in show_pieces


func _ready():
	#not a copy, arrays are shared by reference
	grid_matrix = Global.grid_matrix
	
	ui.visible = true
	background.initializate()
	
	#hide_objective_piece()
	#
	#func hide_objective_piece() -> void:
	#objective_piece.visible = false
	#objective_piece.selectable = false
	
	ui.update_sprite(objective_piece)
	grid.tile_clicked.connect(on_tile_click)
	grid.piece_clicked.connect(on_piece_click)
	
	show_pieces(true)
	camera.update_zoom()


func _process(_delta):
	process_input()


func process_input() -> void:
	if Input.is_action_just_pressed("right_click"):
		set_selected_piece(null)
		
	if Input.is_action_just_pressed("restart"): 
		restart_level()


func set_selected_piece(piece: Piece) -> void:
	if not piece:
		if selected_piece:
			selected_piece.set_selected(false)
			highlight_piece_valid_tiles(false, selected_piece)
		selected_piece = null
		return
	
	# get rid of current selected piece if selecting it again
	if selected_piece and selected_piece == piece:
		selected_piece.set_selected(false)
		highlight_piece_valid_tiles(false, selected_piece)
		selected_piece = null
		return
	
	#deselect current
	if selected_piece:
		selected_piece.set_selected(false)
		highlight_piece_valid_tiles(false, selected_piece)
	
	#select new
	piece.set_selected(true)
	highlight_piece_valid_tiles(true, piece)
	selected_piece = piece


func highlight_piece_valid_tiles(boolean: bool, piece: Piece) -> void:
	var positions = piece.valid_tiles
	
	for pos in positions:
		highlight_tile(boolean, pos)


func highlight_tile(boolean: bool, pos: Vector2) -> void:
	Global.get_tile_at_pos(pos).set_highlight(boolean)


func on_piece_click(piece: Piece) -> void:
	if not can_play: return
	
	if not selected_piece:
		piece.set_selected(true)
		selected_piece = piece
		return
		
	if (piece == selected_piece):
		selected_piece = null;
		piece.set_selected(false)
		return
	
	if (not piece.position in selected_piece.valid_tiles and piece.selectable and piece.moves_left):
		selected_piece.set_selected(false)
		piece.set_selected(true)
		selected_piece = piece
		return
	
	if piece.position in selected_piece.valid_tiles and piece.colour != selected_piece.colour:
		piece._on_being_eaten(selected_piece)
		selected_piece._on_eating(piece)
		highlight_piece_valid_tiles(false, selected_piece)
		move_piece_to_pos(selected_piece, piece.position)
		highlight_piece_valid_tiles(true, selected_piece)
		piece_eaten.emit(piece)
		return


func on_tile_click(tile: Tile) -> void:
	if not can_play: return
	
	#activate tile on click effect
	
	if not selected_piece: return
	
	#if there's a piece in the tile, let the piece handle the input
	if Global.get_piece_at_pos(tile.position): return
	
	if (tile.position in selected_piece.valid_tiles):
		move_piece_to_pos(selected_piece, tile.position)
		return
	
	if not (tile.position in selected_piece.valid_tiles): 
		set_selected_piece(null)


func move_piece_to_pos(piece: Piece, pos: Vector2i) -> void:
	# clear the piece from the spot the piece was on and set it on the new tile
	Global.modify_matrix_piece_at_pos(piece.position, null)
	Global.modify_matrix_piece_at_pos(pos, piece)
	
	piece.move(pos)


func show_pieces(value: bool) -> void:
	can_play = false
	#idk if necessary, but won't it loop endlessly if I use the function?
	var piece_array = pieces.get_children()
	
	for piece in piece_array:
		await get_tree().create_timer(0.1).timeout
		if value:
			piece.appear()
		else:
			piece.disappear()
	can_play = true
	finished.emit()


func check_if_won() -> bool:
	var pieces_left = pieces.get_children()
	pieces_left.filter(func(piece): return piece.alive)
	print(pieces_left)
	if (pieces_left.size() > 1): return false
	if (pieces_left[0].piece_name != objective_piece.piece_name): return false
	if (pieces_left[0].colour != objective_piece.colour): return false
#
	print("omg yu guon")
	return true


func restart_level() -> void:
	#weird artifact n crash if spammed
	#show_pieces(false)
	#await self.finished
	#await get_tree().create_timer(0.50).timeout
	Global.reset_vars()
	get_tree().reload_current_scene()


#func modify_matrix_at_pos()(pos: Vector2, new_values: Array) -> void:
	#assert(new_values.size() == 2, "The array should only contain [tile, piece]")
	#grid_matrix[pos.y/Global.TILE_SIZE][pos.x/Global.TILE_SIZE][0] = new_values[0]
	#grid_matrix[pos.y/Global.TILE_SIZE][pos.x/Global.TILE_SIZE][1] = new_values[1]


#func get_manhattan_distance(pos1: Vector2, pos2: Vector2) -> int:
	#var x_amount = abs(pos1.x-pos2.x)
	#var y_amount = abs(pos1.y-pos2.y)
	#
	#return (x_amount + y_amount)/Global.TILE_SIZE 
