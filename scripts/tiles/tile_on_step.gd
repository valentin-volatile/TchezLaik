extends Tile
class_name TileOnStep

@export var activation_amount: int = 1

func _ready():
	Global.grid_changed.connect(_on_step)


func _on_step() -> void:
	if Global.get_piece_at_pos(position):
		var piece: Piece = Global.get_piece_at_pos(position)
		prints(piece.colour, piece.piece_name, "stepped on me at", position)
