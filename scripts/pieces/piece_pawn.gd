extends Piece
class_name PiecePawn

func _set_up_directions() -> void:
	move_directions = []
	#move_directions = [Vector2(0, Global.TILE_SIZE)]
	#eat_directions = [Vector2(Global.TILE_SIZE, -Global.TILE_SIZE), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE)]



#
#func _update_valid_tiles() -> void:
	## each piece should overwrite this function
	#valid_tiles = []
	#var positions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), 
					#Vector2(0, Global.TILE_SIZE), Vector2(0, -Global.TILE_SIZE),
					#Vector2(Global.TILE_SIZE, Global.TILE_SIZE), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE),
					#Vector2(-Global.TILE_SIZE, Global.TILE_SIZE), Vector2(Global.TILE_SIZE, -Global.TILE_SIZE)]
	#
	#for i in positions:
		#if (position.x + i.x < 0 or position.y + i.y < 0): continue
		#valid_tiles.append(Vector2(position.x + i.x, position.y + i.y))
