extends Piece
class_name PieceRook

func _set_up_directions() -> void:
	move_directions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), Vector2(0, Global.TILE_SIZE), Vector2(0, -Global.TILE_SIZE)]
	eat_directions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), Vector2(0, Global.TILE_SIZE), Vector2(0, -Global.TILE_SIZE)]


#func _update_valid_tiles() -> void:
	## each piece should overwrite this function
	#valid_tiles = []
	#var positions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), Vector2(0, Global.TILE_SIZE), Vector2(0, -Global.TILE_SIZE)]
	#for i in positions:
		#for j in 10: #to increase the range, arbitrary number that should work for all boards
			## ignore negative pos, but it will still add out-of-the-board tiles (level ignores those tiles)
			#if (position.x + (i.x*(j+1)) < 0 or position.y + (i.y*(j+1)) < 0): continue
			#valid_tiles.append(Vector2(position.x + (i.x*(j+1)), position.y + (i.y*(j+1))))
		#
