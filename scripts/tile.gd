extends Node2D
class_name Tile

signal was_clicked(tile:Tile)

@export var jumpable: bool = true
@export var stops_movement: bool = false

@onready var pos_label = $Label
@onready var sprite = $Sprite


var colour: Color
var highlight_amount: float = 0.14
var highlight_colour = Color(highlight_amount, highlight_amount, highlight_amount)


func show_debug_info(value: bool) -> void:
	pos_label.text = str(position)
	pos_label.visible = value


func set_highlight(boolean: bool) -> void:
	if boolean:
		#sprite.self_modulate = colour + highlight_colour
		sprite.self_modulate = Color.BLACK
	else:
		sprite.self_modulate = colour


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("left_click"):
		was_clicked.emit(self)


func _on_piece_step(piece: Piece) -> void:
	prints(piece.colour, piece.piece_name, "stepped on me at", position)
