extends TileOnStep

func _on_step(trigger_piece: Piece) -> void:
	var move_vector: Vector2 = (position - trigger_piece.last_pos).normalized()
	move_vector.x = snapped(move_vector.x, 1)
	move_vector.y = snapped(move_vector.y, 1)
	
	var step: Vector2 = (Vector2(Global.TILE_SIZE, Global.TILE_SIZE) * move_vector)
	
	
	var new_pos: Vector2 = position + step
	
	for i in max(Global.grid_columns, Global.grid_rows):
		if !trigger_piece.is_valid_move(new_pos+step): break
		new_pos += step
	
	#new_pos contains the last empty tile the piece can move into
	#check if the following one has a capturable piece or a gap and act accordingly
	var piece_at_pos: Piece = Global.get_piece_at_pos(new_pos+step) if Global.is_in_grid(new_pos+step) else null
	var tile_at_pos: Tile = Global.get_tile_at_pos(new_pos+step) if Global.is_in_grid(new_pos+step) else null
	
	if piece_at_pos and trigger_piece.can_capture(piece_at_pos):
		new_pos += step
		trigger_piece.move(new_pos)
		trigger_piece._on_capturing(piece_at_pos)
		piece_at_pos._on_being_captured(trigger_piece)
		return
	
	trigger_piece.move(new_pos)
	
