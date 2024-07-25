extends Node2D
class_name Level

signal solved

@export var moves_amount: int

@onready var background = $Background
@onready var ui = $LevelUI
@onready var grid: Grid = $Grid
@onready var pieces = $Grid/Pieces
@onready var camera = $Camera2D

var selected_piece: Piece = null
var can_play: bool = false #set in show_pieces


func _ready():
	ui.visible = true
	background.initializate()
	ui.update_counter(moves_amount)
	
	Global.piece_captured.connect(check_if_won)
	grid.tile_clicked.connect(on_tile_click)
	grid.piece_clicked.connect(on_piece_click)
	
	show_pieces(true)
	camera.update_zoom()


func _process(_delta):
	process_input()


func process_input() -> void:
	if Input.is_action_just_pressed("right_click"):
		set_selected_piece(null)


func set_selected_piece(piece: Piece) -> void:
	if piece: piece.update_valid_tiles()
	
	if not piece:
		if selected_piece:
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
	for pos in piece.move_tiles:
		highlight_tile(boolean, pos, false)
	
	for pos in piece.capture_tiles:
		var enemy_piece = Global.get_piece_at_pos(pos)
		if enemy_piece and enemy_piece.colour != piece.colour:
			highlight_tile(boolean, pos, true)
	
	#for pos in piece.checked_tiles:
		#highlight_tile(boolean, pos, true)


func highlight_tile(boolean: bool, pos: Vector2, capture_colour: bool) -> void:
	Global.get_tile_at_pos(pos).set_highlight(boolean, capture_colour)


func on_piece_click(piece: Piece) -> void:
	if not can_play: return
	if not moves_amount: return

	if not selected_piece:
		set_selected_piece(piece)
		return
		
	if (piece == selected_piece):
		set_selected_piece(null)
		return
	
	if piece.position in selected_piece.capture_tiles:
		var current_piece = selected_piece
		set_selected_piece(null)
		current_piece.capture(piece)
		if current_piece.moves_when_capturing: Global.emit_piece_moved(current_piece)
		Global.emit_piece_captured(piece)
		update_move_counter(-1)
		return
		
	if (not piece.position in selected_piece.move_tiles and piece.selectable):
		set_selected_piece(piece)
		return


func on_tile_click(tile: Tile) -> void:
	if not can_play: return
	if not moves_amount: return
	if not selected_piece: return
	
	#if there's a piece in the tile, let the piece handle the input
	if Global.get_piece_at_pos(tile.position): return
	
	if (tile.position in selected_piece.move_tiles):
		var current_piece = selected_piece
		can_play = false
		update_move_counter(-1)
		set_selected_piece(null)
		await current_piece.move(tile.position)
		can_play = true
		Global.emit_piece_moved(current_piece)
		
		return
	
	if not (tile.position in selected_piece.move_tiles): 
		set_selected_piece(null)


func on_piece_started_animation() -> void:
	can_play = false


func on_piece_finished_animation() -> void:
	can_play = true


func show_pieces(value: bool) -> void:
	can_play = false
	var piece_array = pieces.get_children()
	
	for piece in piece_array:
		await get_tree().create_timer(0.1).timeout
		if value:
			piece.appear()
		else:
			piece.disappear()
	can_play = true
	#finished.emit()


func update_move_counter(amount: int) -> void:
	moves_amount += amount
	ui.update_counter(moves_amount)


func check_if_won(_piece: Piece):
	var pieces_left = Global.pieces.filter(func(piece): return piece.alive)
	if (pieces_left.size() > 1): return
	
	solved.emit()
