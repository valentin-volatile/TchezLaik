extends Piece
class_name PiecePawn


func _set_up_directions() -> void:
	if colour == "white":
		move_directions = [Vector2(0, -Global.TILE_SIZE)]
		eat_directions = [Vector2(Global.TILE_SIZE, -Global.TILE_SIZE), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE)]
	else:
		move_directions = [Vector2(0, Global.TILE_SIZE)]
		eat_directions = [Vector2(Global.TILE_SIZE, Global.TILE_SIZE), Vector2(-Global.TILE_SIZE, Global.TILE_SIZE)]


func _on_eating(piece_eaten: Piece) -> void:
	prints(colour, piece_name, "ate", piece_eaten.colour, piece_eaten.piece_name)
	set_colour(piece_eaten.colour)
	_set_up_directions()

