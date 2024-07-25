extends Piece

func _set_up_directions():
	move_directions = [Vector2(Global.TILE_SIZE*2, Global.TILE_SIZE), Vector2(Global.TILE_SIZE*2, -Global.TILE_SIZE),
				Vector2(-Global.TILE_SIZE*2, Global.TILE_SIZE), Vector2(-Global.TILE_SIZE*2, -Global.TILE_SIZE),
				Vector2(Global.TILE_SIZE, Global.TILE_SIZE*2), Vector2(Global.TILE_SIZE, -Global.TILE_SIZE*2),
				Vector2(-Global.TILE_SIZE, Global.TILE_SIZE*2), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE*2)]
	
	capture_directions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), Vector2(0, Global.TILE_SIZE), Vector2(0, -Global.TILE_SIZE)]


func _update_valid_moves() -> void:
	move_tiles = []
	for dir in move_directions:
		var new_pos = position + dir
		
		if not is_valid_move(new_pos): continue
		move_tiles.append(new_pos)
