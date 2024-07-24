extends SafePiece
class_name PieceKing

func _set_up_directions() -> void:
	move_directions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), Vector2(0, Global.TILE_SIZE), 
					Vector2(0, -Global.TILE_SIZE), Vector2(Global.TILE_SIZE, Global.TILE_SIZE), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE),
					Vector2(-Global.TILE_SIZE, Global.TILE_SIZE), Vector2(Global.TILE_SIZE, -Global.TILE_SIZE)]
	
	capture_directions = [Vector2(Global.TILE_SIZE, 0), Vector2(-Global.TILE_SIZE, 0), Vector2(0, Global.TILE_SIZE), 
					Vector2(0, -Global.TILE_SIZE), Vector2(Global.TILE_SIZE, Global.TILE_SIZE), Vector2(-Global.TILE_SIZE, -Global.TILE_SIZE),
					Vector2(-Global.TILE_SIZE, Global.TILE_SIZE), Vector2(Global.TILE_SIZE, -Global.TILE_SIZE)]

#
#func update_valid_tiles() -> void:
	#checked_tiles = []
	#_update_valid_captures()
	#_update_valid_moves()
	#
	#var attack_tiles = Global.get_attacked_pos(self)
	##copy, as arrays are passed by reference and cannot erase while iterating
	#var capture_tiles_copy = capture_tiles.duplicate()
	#var move_tiles_copy = move_tiles.duplicate()
	#
	#for cap_move in capture_tiles_copy:
		#if move in attack_tiles: capture_tiles.erase(move)
	#
	#for move in move_tiles_copy:
		#if move in attack_tiles: move_tiles.erase(move)
