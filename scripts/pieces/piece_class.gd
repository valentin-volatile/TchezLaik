extends Node2D
class_name Piece

signal was_clicked(piece: Piece)

@export var piece_name: String
@export_enum("black", "white") var colour: String = "black"

# if null, suppose it moves along the whole axis and eats the same way 
@export var move_reach: int 
@export var eat_reach: int
@export var can_jump_over_obstacles: bool = false
@export var stops_movement: bool = true

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Pivot/Sprite

var colours = {"black": Global.PIECE_BLACK, "white": Global.PIECE_WHITE}
var highlight_amount: float = 0.140
var highlight_colour := Color(highlight_amount, highlight_amount, highlight_amount, 0)

var move_directions
var eat_directions
var valid_tiles := []
var selectable := false
var is_selected := false
var alive := true
var moves_left := 1

# for tweening
var move_time := 0.45 #0.3
var move_rotation = 1
var being_tweened := false


func _ready():
	visible = false
	modulate = colours[colour]
	_set_up_directions()
	_update_valid_tiles()


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if moves_left == 0: return
	
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


func add_moves(amount: int) -> void:
	moves_left += amount


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


func move_and_eat() -> void:
	pass

func move(pos: Vector2) -> void:
	if moves_left == 0: return
	add_moves(-1)
	
	sprite.scale = Vector2(0.75, 0.75)
	rotation_degrees = 0 if (position.x == pos.x) else -move_rotation * sign(position.x-pos.x) 
	
	selectable = false
	being_tweened = true
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", pos, move_time).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2(1, 1), move_time).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "rotation", 0, move_time).set_trans(Tween.TRANS_ELASTIC)
	
	await tween.finished
	being_tweened = false
	selectable = true
	_update_valid_tiles()


#func get_legal_moves() -> Array:
	#var legal_moves = []
	#var grid = Global.grid
	#var moves = move_reach if move_reach else max(Global.grid_rows, Global.grid_columns)
	#
	#for direction in move_directions:
		#for i in moves:
			#var pos = Vector2(position.y+(i*Global.TILE_SIZE), position.x)
			#if is_valid_move(pos): legal_moves.append(pos)
	#return legal_moves


func _update_valid_tiles() -> void:
	# pieces with special rules (pawn, knight) should overwrite this function
	# gets called by grid as the global vars are set in it, so
	# they don't have a value until the grid executes it's ready function
	valid_tiles = []
	
	for dir in move_directions:
		#assume it moves across the whole grid
		for amount in max(Global.grid_columns, Global.grid_rows)-1:
			amount += 1
			var new_pos = Vector2(position.x + (dir.x*amount), position.y + (dir.y*amount))
			if not(is_valid_move(new_pos)): 
				break
			
			valid_tiles.append(new_pos)

func is_valid_move(pos: Vector2) -> bool:
	#returns an array with the validity of the move (true or false) and
	#a piece (or null) if the position is occupied by an enemy
	#if tile is occupied by an enemy, stop calculating movement in that axis
	
	var y = pos.y/Global.TILE_SIZE
	var x = pos.x/Global.TILE_SIZE
	
	#out of range
	if y < 0 or x < 0: return false
	if y >= Global.grid_rows or x >= Global.grid_columns: return false
	
	var pos_contents = Global.get_info_at_pos(pos)
	
	if (pos_contents[0].stops_movement) and not can_jump_over_obstacles:
		return false
	
	if (pos_contents[1] and pos_contents[1].stops_movement):
		return false
		
	return true


func _on_eating(piece_eaten: Piece) -> void:
	add_moves(1)
	set_colour(piece_eaten.colour)
	prints(colour, piece_name, "ate", piece_eaten.colour, piece_eaten.piece_name)


func _on_being_eaten(piece_eaten_by: Piece) -> void:
	prints(colour, piece_name, "got eaten by", piece_eaten_by.colour, piece_eaten_by.piece_name)
	disappear()
