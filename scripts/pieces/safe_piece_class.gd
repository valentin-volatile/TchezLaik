extends Piece
class_name SafePiece

#safe pieces cannot move into a tile or capture a piece that would leave them in check

func update_valid_tiles() -> void:
	checked_tiles = []
	_update_valid_captures()
	_update_valid_moves()
	
	#copy, as arrays are passed by reference and cannot erase while iterating
	var attack_tiles = Global.get_attacked_pos(self)
	var capture_tiles_copy = capture_tiles.duplicate()
	var move_tiles_copy = move_tiles.duplicate()
	var checked_tiles_copy = checked_tiles.duplicate()
	
	for move in capture_tiles_copy:
		if move in attack_tiles: capture_tiles.erase(move)
	
	for move in move_tiles_copy:
		if move in attack_tiles: move_tiles.erase(move)
	
	for move in checked_tiles_copy:
		if move in attack_tiles: checked_tiles.erase(move)
