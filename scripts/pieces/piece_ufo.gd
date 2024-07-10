extends SafePiece
class_name PieceUFO

func _set_up_directions() -> void:
	move_directions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), Vector2(0, Global.TILE_SIZE), 
					Vector2(0, -Global.TILE_SIZE), Vector2(Global.TILE_SIZE, Global.TILE_SIZE), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE),
					Vector2(-Global.TILE_SIZE, Global.TILE_SIZE), Vector2(Global.TILE_SIZE, -Global.TILE_SIZE)]
	
	capture_directions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), Vector2(0, Global.TILE_SIZE), 
					Vector2(0, -Global.TILE_SIZE), Vector2(Global.TILE_SIZE, Global.TILE_SIZE), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE),
					Vector2(-Global.TILE_SIZE, Global.TILE_SIZE), Vector2(Global.TILE_SIZE, -Global.TILE_SIZE)]


func _update_valid_moves() -> void:
	if not Global.grid_matrix: return #avoid crash, as pieces are set up before the grid
	
	move_tiles = []
	
	var attacked_tiles = Global.get_attacked_pos(self)
	
	for row in Global.grid_rows:
		for column in Global.grid_columns:
			var new_pos = Vector2(Global.TILE_SIZE*row, Global.TILE_SIZE*column)
			
			if (new_pos == position): continue
			
			if not(is_valid_move(new_pos)): continue
			
			move_tiles.append(new_pos)


func _update_valid_captures() -> void:	
	capture_tiles = []
	
	for row in Global.grid_rows:
		for column in Global.grid_columns:
			var new_pos = Vector2(row*Global.TILE_SIZE, column*Global.TILE_SIZE)
			
			if (new_pos == position): continue
			
			if not Global.is_in_grid(new_pos): break
			
			var piece = Global.get_piece_at_pos(new_pos)
			
			if not piece: 
				checked_tiles.append(new_pos)
				continue
			
			if piece.colour != colour:
				capture_tiles.append(new_pos)
			else:
				checked_tiles.append(new_pos)
