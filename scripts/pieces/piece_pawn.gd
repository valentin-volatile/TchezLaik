extends Piece
class_name PiecePawn

func _set_up_directions() -> void:
	if colour == "white":
		move_directions = [Vector2(0, -Global.TILE_SIZE)]
		capture_directions = [Vector2(Global.TILE_SIZE, -Global.TILE_SIZE), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE)]
	else:
		move_directions = [Vector2(0, Global.TILE_SIZE)]
		capture_directions = [Vector2(Global.TILE_SIZE, Global.TILE_SIZE), Vector2(-Global.TILE_SIZE, Global.TILE_SIZE)]
