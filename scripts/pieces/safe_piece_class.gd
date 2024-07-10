extends Piece
class_name SafePiece

#safe pieces cannot move into a tile or capture a piece that would leave them in check

func _get_safe_piece_checked_tiles() -> Array:
	var positions = [Vector2(Global.TILE_SIZE+position.x, position.y), Vector2(-Global.TILE_SIZE+position.x, position.y), Vector2(position.x, Global.TILE_SIZE+position.y), 
					Vector2(position.x, -Global.TILE_SIZE+position.y), Vector2(Global.TILE_SIZE+position.x, Global.TILE_SIZE+position.y), Vector2(-Global.TILE_SIZE+position.x, -Global.TILE_SIZE+position.y),
					Vector2(-Global.TILE_SIZE+position.x, Global.TILE_SIZE+position.y), Vector2(Global.TILE_SIZE+position.x, -Global.TILE_SIZE+position.y)]
	return positions


func update_valid_tiles() -> void:
	checked_tiles = []
	_update_valid_captures()
	_update_valid_moves()
	
	var attack_tiles = Global.get_attacked_pos(self)
	
	#copy, as arrays are passed down by reference and cannot erase while iterating
	var capture_tiles_copy = capture_tiles.duplicate()
	var move_tiles_copy = move_tiles.duplicate()
	var checked_tiles_copy = checked_tiles.duplicate()
	
	for possible_move in capture_tiles_copy:
		if possible_move in attack_tiles: capture_tiles.erase(possible_move)
	
	for possible_move in move_tiles_copy:
		if possible_move in attack_tiles: move_tiles.erase(possible_move)
	
	for possible_move in checked_tiles_copy:
		if possible_move in attack_tiles: checked_tiles.erase(possible_move)
