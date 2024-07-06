extends Piece
class_name PieceKnight


func _set_up_directions():
	var positions = [Vector2(Global.TILE_SIZE*2, Global.TILE_SIZE), Vector2(Global.TILE_SIZE*2, -Global.TILE_SIZE),
				Vector2(-Global.TILE_SIZE*2, Global.TILE_SIZE), Vector2(-Global.TILE_SIZE*2, -Global.TILE_SIZE),
				Vector2(Global.TILE_SIZE, Global.TILE_SIZE*2), Vector2(Global.TILE_SIZE, -Global.TILE_SIZE*2),
				Vector2(-Global.TILE_SIZE, Global.TILE_SIZE*2), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE*2)]
	
	move_directions = positions
	eat_directions = positions


func _update_valid_moves() -> void:
	move_tiles = []
	for dir in move_directions:
		var new_pos = position + dir
		
		if not is_valid_move(new_pos): continue
		move_tiles.append(new_pos)


func _update_valid_captures() -> void:
	capture_tiles = []
	
	for dir in eat_directions:
		var new_pos = position + dir
		
		if not Global.is_in_grid(new_pos): break
		var piece = Global.get_piece_at_pos(new_pos)
		
		if piece and piece.colour == colour: break
			
		capture_tiles.append(new_pos)
		break
