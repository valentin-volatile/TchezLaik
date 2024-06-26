extends Node2D
class_name Tile

signal was_clicked(tile:Tile)

@export var jumpable: bool = true
@export var stops_movement: bool = false

@onready var pos_label = $Label
@onready var sprite = $Sprite


var colour: String
#var highlight_strength: int = 1
#var highlight_colour = Color8(highlight_strength, highlight_strength, highlight_strength, 50)


func show_debug_info(value: bool) -> void:
	pos_label.text = str(position)
	pos_label.visible = value


func set_highlight(boolean: bool) -> void:
	if not boolean: 
		sprite.self_modulate = Global.TILE_COLOURS[colour]
		return
	if colour == "white":
		#sprite.self_modulate = Global.TILE_COLOURS[colour] - highlight_colour
		sprite.self_modulate = Color.TAN
	else:
		#sprite.self_modulate = Global.TILE_COLOURS[colour] - highlight_colour
		sprite.self_modulate = Color.PERU


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("left_click"):
		was_clicked.emit(self)


func update_colour(new_colour: String) -> void:
	colour = new_colour
	sprite.self_modulate = Global.TILE_COLOURS[colour]
