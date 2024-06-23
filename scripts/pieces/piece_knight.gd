extends Piece
class_name PieceKnight


func _set_up_directions():
	move_directions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), Vector2(0, Global.TILE_SIZE), Vector2(0, -Global.TILE_SIZE)]
	eat_directions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), Vector2(0, Global.TILE_SIZE), Vector2(0, -Global.TILE_SIZE)]


func _update_valid_tiles() -> void:
	# each piece should overwrite this function
	valid_tiles = []
	var positions = [Vector2(Global.TILE_SIZE*2, Global.TILE_SIZE), Vector2(Global.TILE_SIZE*2, -Global.TILE_SIZE),
					Vector2(-Global.TILE_SIZE*2, Global.TILE_SIZE), Vector2(-Global.TILE_SIZE*2, -Global.TILE_SIZE),
					Vector2(Global.TILE_SIZE, Global.TILE_SIZE*2), Vector2(Global.TILE_SIZE, -Global.TILE_SIZE*2),
					Vector2(-Global.TILE_SIZE, Global.TILE_SIZE*2), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE*2)]
	for i in positions:
		var new_pos: Vector2
		new_pos = position + i
		if (new_pos.x < 0 or new_pos.y < 0): continue
		valid_tiles.append(new_pos)
		
