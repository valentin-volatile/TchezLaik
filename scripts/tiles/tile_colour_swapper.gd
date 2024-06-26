extends TileOnStep

func _on_step() -> void:
	if not Global.get_piece_at_pos(position): return
	if not activation_amount: return
	activation_amount -= 1
	
	var pieces = Global.get_all_pieces()
	
	for piece in pieces:
		var new_colour = Global.get_tile_at_pos(piece.position).colour
		
		if piece == Global.get_piece_at_pos(position): continue
		
		if new_colour != piece.colour:
			piece.set_colour(new_colour)
