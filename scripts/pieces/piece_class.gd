extends Node2D
class_name Piece

signal was_clicked(piece: Piece)

@export var piece_name: String
@export_enum("black", "white") var colour: String = "black"

# if null, suppose it moves along the whole axis and eats the same way 
@export var move_reach: int 
@export var eat_reach: int
@export var moves_when_eating: bool = true
@export var can_jump_over_obstacles: bool = false
@export var stops_movement: bool = true

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Pivot/Sprite

var colours = {"black": Global.PIECE_BLACK, "white": Global.PIECE_WHITE}
var highlight_amount: float = 0.140
var highlight_colour := Color(highlight_amount, highlight_amount, highlight_amount, 0)

var move_directions := []
var eat_directions := []
var valid_tiles := []
var capture_tiles := []
var selectable := false
var is_selected := false
var alive := true

# for tweening
var move_time := 0.45 #0.3
var move_rotation = 1
var being_tweened := false


func _ready():
	visible = false
	modulate = colours[colour]
	_set_up_directions()
	update_valid_tiles()
	Global.grid_changed.connect(update_valid_tiles)


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if not selectable or being_tweened: return
	
	if Input.is_action_just_pressed("left_click"):
		was_clicked.emit(self)


func _on_area_2d_mouse_entered():
	if being_tweened: return
	
	if not is_selected:
		set_highlight(true)
		anim_player.play("mouse_entered")


func _on_area_2d_mouse_exited():
	if being_tweened: return
	
	if not is_selected:
		set_highlight(false)
		anim_player.play("mouse_exited")


func _set_up_directions():
	#must be overriden
	#move_directions = 
	#eat_directions = 
	pass


func set_selected(value: bool) -> void:
		is_selected = value
		set_highlight(value)
		
		if value:
			anim_player.play("selected")
		else:
			anim_player.play("deselected")


func set_colour(selected_colour: String) -> void:
	colour = selected_colour
	var tween = create_tween()
	var new_modulate = colours[selected_colour]
	#self, modulate
	tween.tween_property(sprite, "self_modulate", new_modulate, 0.25)


func set_highlight(boolean: bool) -> void:
	var tween: Tween = create_tween()
	var final_modulate
	var tween_time = 0.15
	
	if boolean:
		final_modulate = colours[colour] + highlight_colour
		tween.tween_property(self, "modulate", final_modulate, tween_time)
	else:
		final_modulate = colours[colour]
		tween.tween_property(self, "modulate", final_modulate, tween_time)


func appear() -> void:
	selectable = false
	anim_player.play("appear")
	await anim_player.animation_finished
	selectable = true


func disappear() -> void:
	anim_player.play("disappear")
	await anim_player.animation_finished
	selectable = false
	visible = false


func eat(piece: Piece) -> void:
	if moves_when_eating:
		move(piece.position)
	
	_on_eating(piece)
	piece._on_being_eaten(self)


func move(pos: Vector2) -> void:
	selectable = false
	being_tweened = true
	
	Global.modify_matrix_piece_at_pos(position, null)
	Global.modify_matrix_piece_at_pos(pos, self)
	
	sprite.scale = Vector2(0.75, 0.75)
	rotation_degrees = 0 if (position.x == pos.x) else -move_rotation * sign(position.x-pos.x) 
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", pos, move_time).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2(1, 1), move_time).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "rotation", 0, move_time).set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	
	position = pos
	update_valid_tiles()
	being_tweened = false
	selectable = true


func update_valid_tiles() -> void:
	_update_valid_captures()
	_update_valid_moves()


func _update_valid_moves() -> void:
	# pieces with special rules (pawn, knight) should overwrite this function
	# gets called by grid (as the global vars are set in it), so
	# they don't have a value until the grid executes it's ready function
	valid_tiles = []
	
	for dir in move_directions:
		#assume it moves across the whole grid
		for amount in max(Global.grid_columns, Global.grid_rows)-1:
			#otherwise checks the position the piece is in for every direction, and stops there
			amount += 1
			var new_pos = Vector2(position.x + (dir.x*amount), position.y + (dir.y*amount))
			if not(is_valid_move(new_pos)): 
				break
			
			valid_tiles.append(new_pos)


func _update_valid_captures() -> void:
	# pieces with special rules (pawn, knight) should overwrite this function
	# gets called by grid (as the global vars are set in it), so
	# they don't have a value until the grid executes it's ready function
	capture_tiles = []
	
	for dir in eat_directions:
		#assume it eats across the whole grid
		for amount in max(Global.grid_columns, Global.grid_rows)-1:
			amount += 1
			var new_pos = Vector2(position.x + (dir.x*amount), position.y + (dir.y*amount))
			
			if not Global.is_in_grid(new_pos): break
			var piece = Global.get_piece_at_pos(new_pos)
			
			if piece and piece.colour != colour:
				capture_tiles.append(new_pos)


func is_valid_move(pos: Vector2) -> bool:
	#returns an array with the validity of the move (true or false) and
	#a piece (or null) if the position is occupied by an enemy
	#if tile is occupied by an enemy, stop calculating movement in that axis

	#out of range
	if not Global.is_in_grid(pos): return false
	
	var pos_contents = Global.get_info_at_pos(pos)
	
	if (pos_contents[0].stops_movement) and not can_jump_over_obstacles:
		return false
	
	if (pos_contents[1] and pos_contents[1].stops_movement):
		return false
		
	return true


func _on_eating(piece_eaten: Piece) -> void:
	set_colour(piece_eaten.colour)
	prints(colour, piece_name, "ate", piece_eaten.colour, piece_eaten.piece_name)


func _on_being_eaten(piece_eaten_by: Piece) -> void:
	alive = false
	prints(colour, piece_name, "got eaten by", piece_eaten_by.colour, piece_eaten_by.piece_name)
	disappear()
