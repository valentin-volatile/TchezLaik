extends Piece
class_name PieceKing

func _set_up_directions() -> void:
	move_directions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), Vector2(0, Global.TILE_SIZE), 
					Vector2(0, -Global.TILE_SIZE), Vector2(Global.TILE_SIZE, Global.TILE_SIZE), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE),
					Vector2(-Global.TILE_SIZE, Global.TILE_SIZE), Vector2(Global.TILE_SIZE, -Global.TILE_SIZE)]
	
	eat_directions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), Vector2(0, Global.TILE_SIZE), 
					Vector2(0, -Global.TILE_SIZE), Vector2(Global.TILE_SIZE, Global.TILE_SIZE), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE),
					Vector2(-Global.TILE_SIZE, Global.TILE_SIZE), Vector2(Global.TILE_SIZE, -Global.TILE_SIZE)]


func _update_valid_moves() -> void:
	move_tiles = []
	var attacked_tiles = Global.get_attacked_pos(colour)
	print(attacked_tiles)
	for dir in move_directions:
		var new_pos = position + dir
		
		if not(is_valid_move(new_pos)): 
			continue
		
		if not (new_pos in attacked_tiles):
			move_tiles.append(new_pos)
