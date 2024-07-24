extends Node2D
class_name Piece

signal started_animation
signal finished_animation
signal was_clicked(piece: Piece)

@export var piece_name: String
@export_enum("black", "white") var colour: String = "black"

#suppose it moves along the whole axis and captures the same way, use it for pieces
# that don't work that way
@export_group("Movement")
@export var move_reach: int 
@export var capture_reach: int
@export var moves_when_capturing: bool = true
@export var can_jump_over_obstacles: bool = false
#whether other pieces will consider this piece as blocking their movement
@export var stops_movement: bool = true
@export var colour_affects_movement: bool = false
@export_group("")


@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_pivot = $Pivot
@onready var sprite_dark: Sprite2D = $Pivot/Dark
@onready var sprite_medium: Sprite2D = $Pivot/Medium
@onready var sprite_light: Sprite2D = $Pivot/Light
@onready var audio_move: AudioStreamPlayer2D = $AudioMove

var highlight_amount: float = 0.140
var highlight_colour := Color(highlight_amount, highlight_amount, highlight_amount, 0)

var move_directions := []
var capture_directions := []
var move_tiles := []
var capture_tiles := []
#empty tiles this unit is putting in check (necessary for the ufo and king)
var checked_tiles := []
var selectable := false
var is_selected := false
var alive := true

# for tweening
var move_time := 0.45 #0.3
var move_rotation = 5
var being_tweened := false

var allowed_colour_captures: Dictionary = {
	"white" = ["black"],
	"black" = ["white"],
}


func _ready():
	sprite_pivot.visible = false
	set_colour(colour, false)
	_set_up_directions()


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if not selectable or being_tweened: return
	
	if Input.is_action_just_pressed("left_click"):
		was_clicked.emit(self)


func _on_area_2d_mouse_entered():
	if not selectable or being_tweened: return
	
	if not is_selected:
		set_highlight(true)
		anim_player.play("mouse_entered")


func _on_area_2d_mouse_exited():
	if not selectable or being_tweened: return
	
	if not is_selected:
		set_highlight(false)
		anim_player.play("mouse_exited")


func _set_up_directions():
	#move_directions = 
	#capture_directions = 
	pass


func set_selected(value: bool) -> void:
		is_selected = value
		set_highlight(value)
		
		if value:
			anim_player.play("selected")
		else:
			anim_player.play("deselected")


func set_colour(selected_colour: String, animation: bool = true) -> void:
	colour = selected_colour
	var new_colours = Global.PIECE_COLOURS[selected_colour]
	
	sprite_dark.self_modulate = new_colours["dark"]
	sprite_medium.self_modulate = new_colours["medium"]
	sprite_light.self_modulate = new_colours["light"]
	#self, modulate
	#var tween = crcapturee_tween()
	#tween.tween_property(sprite, "self_modulate", new_modulate, 0.25)


func set_highlight(boolean: bool) -> void:
	#var tween: Tween = crcapturee_tween()
	#var final_modulate
	#var tween_time = 0.15
	
	#if boolean:
		#final_modulate = colours[colour] + highlight_colour
		#tween.tween_property(self, "modulate", final_modulate, tween_time)
	#else:
		#final_modulate = colours[colour]
		#tween.tween_property(self, "modulate", final_modulate, tween_time)
	pass


func appear() -> void:
	visible = true
	selectable = false
	sprite_pivot.visible = true
	sprite_pivot.scale = Vector2.ZERO
	
	anim_player.play("appear")
	await anim_player.animation_finished
	
	selectable = true


func disappear() -> void:
	visible = true
	selectable = false
	
	anim_player.play("disappear")
	await anim_player.animation_finished
	
	visible = false
	finished_animation.emit()


func capture(piece: Piece) -> void:
	if moves_when_capturing:
		play_audio("capture", move_time-0.05) #magic number
		move(piece.position, false)
	
	Global.emit_grid_changed()
	_on_capturing(piece)
	piece._on_being_captured(self)


func move(pos: Vector2, play_sound: bool = true) -> void:
	selectable = false

	Global.modify_matrix_piece_at_pos(position, null)
	Global.modify_matrix_piece_at_pos(pos, self)
	
	#connected to level, blocks/resumes all input
	started_animation.emit()
	await play_move_animation(pos, play_sound)
	
	Global.emit_grid_changed()
	finished_animation.emit()

func play_move_animation(pos: Vector2, play_sound: bool = true) -> void:
	being_tweened = true
	sprite_pivot.scale = Vector2(0.75, 0.75)
	rotation_degrees = 0 if (position.x == pos.x) else -move_rotation * sign(position.x-pos.x) 
	
	if play_sound: play_audio("move", move_time-0.05)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "position", pos, move_time).set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite_pivot, "scale", Vector2(1, 1), move_time).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "rotation", 0, move_time).set_trans(Tween.TRANS_ELASTIC)
	await tween.finished
	
	position = pos
	being_tweened = false
	selectable = true


func play_audio(sound: String, delay: float = 0.0):
	if delay:
		await get_tree().create_timer(delay).timeout
		
	match sound:
		"move":
			audio_move.play()


func update_valid_tiles() -> void:
	checked_tiles = []
	if colour_affects_movement: _set_up_directions()
	_update_valid_captures()
	_update_valid_moves()


func _update_valid_moves() -> void:
	# pieces with special rules (pawn, knight) should overwrite this function
	# gets called by grid (as the global vars are set in it), so
	# they don't have a value until the grid executes it's ready function
	move_tiles = []
	
	#necessary
	var move_amount = (move_reach+1) if move_reach else max(Global.grid_columns, Global.grid_rows)
	
	for dir in move_directions:
		for amount in move_amount:
			var new_pos = Vector2(position.x + (dir.x*amount), position.y + (dir.y*amount))
			
			if (new_pos == position): continue
			
			if not(is_valid_move(new_pos)): break
			
			move_tiles.append(new_pos)


func _update_valid_captures() -> void:
	# pieces with special rules (pawn, knight) should overwrite this function
	# gets called by grid (as the global vars are set in it), so
	# they don't have a value until the grid executes it's ready function
	capture_tiles = []
	
	var capture_amount = (capture_reach+1) if capture_reach else max(Global.grid_columns, Global.grid_rows)
	
	for dir in capture_directions:
		for amount in capture_amount:
			var new_pos = position + (dir*amount)
			
			if (new_pos == position): continue
			
			if not Global.is_in_grid(new_pos): break
			
			var piece = Global.get_piece_at_pos(new_pos)
			
			if not piece: 
				checked_tiles.append(new_pos)
				continue
			
			if can_capture(piece):
				capture_tiles.append(new_pos)

			checked_tiles.append(new_pos)
			break


func can_capture(piece: Piece) -> bool:
	if piece.colour in allowed_colour_captures[colour]: return true
	return false


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


func _on_capturing(piece_captured: Piece) -> void:
	prints(colour, piece_name, "captured", piece_captured.colour, piece_captured.piece_name)
	set_colour(piece_captured.colour)


func _on_being_captured(_piece_captured_by: Piece) -> void:
	alive = false
	disappear()
