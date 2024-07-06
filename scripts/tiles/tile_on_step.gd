extends Tile
class_name TileOnStep

@export var activation_amount: int = 1

func _ready():
	Global.grid_changed.connect(check_if_stepped)


func check_if_stepped() -> void:
	var piece = Global.get_piece_at_pos(position)
	if piece: _on_step(piece)


func _on_step(trigger_piece: Piece) -> void:
	prints(trigger_piece.colour, trigger_piece.piece_name, "stepped on me at", position)
