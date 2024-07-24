extends Tile
class_name TileOnStep
#step on is managed first, then step off

@export var activates_on_step_on: bool
@export var activates_on_step_off: bool
@export var activation_amount: int = 1

var piece_on_this_tile: Piece


func _set_up() -> void:
	piece_on_this_tile = Global.get_piece_at_pos(position)
	Global.grid_changed.connect(check_if_stepped_on)
	Global.grid_changed.connect(check_if_stepped_off)


func check_if_stepped_on() -> void:
	if not(activation_amount): return
	var piece = Global.get_piece_at_pos(position)
	
	if piece and piece_on_this_tile != piece:
		piece_on_this_tile = piece
		if activates_on_step_on:
			activation_amount -= 1
			_on_step(piece)


func check_if_stepped_off() -> void:
	if not(activation_amount): return
	
	var piece = Global.get_piece_at_pos(position)
	
	if piece_on_this_tile != piece:
		if activates_on_step_off:
			activation_amount -= 1
			_on_step_off(piece if piece else piece_on_this_tile)
		piece_on_this_tile = piece


func _on_step(trigger_piece: Piece) -> void:
	prints(trigger_piece.colour, trigger_piece.piece_name, "stepped on me at", position)


func _on_step_off(trigger_piece: Piece) -> void:
	prints(trigger_piece.colour, trigger_piece.piece_name, "stepped off of me at", position)
