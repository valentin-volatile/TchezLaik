extends Tile
class_name TileOnStep

@export var activates_on_step_on: bool
@export var activates_on_step_off: bool
@export var activation_amount: int = 1


var piece_on_this_tile: Piece

func _set_up() -> void:
	piece_on_this_tile = Global.get_piece_at_pos(position)
	Global.piece_moved.connect(check_if_stepped_on)
	Global.piece_moved.connect(check_if_stepped_off)
	Global.piece_captured.connect(check_if_stepped_on)
	Global.piece_captured.connect(check_if_stepped_off)

func check_if_stepped_on(piece: Piece) -> void:
	#is activated when capturing a piece on this tile
	if not(activates_on_step_on) or not(activation_amount): return
	
	if piece_on_this_tile != Global.get_piece_at_pos(position):
		if not Global.get_piece_at_pos(position): return
		piece_on_this_tile = Global.get_piece_at_pos(position)
		activation_amount -= 1
		_on_step(piece)
	
	#if piece_on_this_tile and Global.get_piece_at_pos(position) != piece_on_this_tile:
		#piece_on_this_tile = Global.get_piece_at_pos(position)
		#activation_amount -= 1
		#_on_step(piece)
	#elif (piece_on_this_tile == null) and (piece == Global.get_piece_at_pos(position)):
		#piece_on_this_tile = piece
		#activation_amount -= 1
		#_on_step(piece)



func check_if_stepped_off(piece: Piece) -> void:
	if not(activates_on_step_off) or not(activation_amount): return
	
	if (piece_on_this_tile == piece) and (Global.get_piece_at_pos(position) != piece):
		#could check for == null, but this lets you detect when another piece captures the one that was on this tile
		piece_on_this_tile = null
	
		activation_amount -= 1
		_on_step_off(piece)


func _on_step(trigger_piece: Piece) -> void:
	prints(trigger_piece.colour, trigger_piece.piece_name, "stepped on me at", position)

func _on_step_off(trigger_piece: Piece) -> void:
	prints(trigger_piece.colour, trigger_piece.piece_name, "stepped off of me at", position)
