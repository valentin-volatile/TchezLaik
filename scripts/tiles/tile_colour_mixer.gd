extends TileOnStep

func _on_step(trigger_piece: Piece) -> void:
	if not activation_amount: return
	activation_amount -= 1
	
	var pieces = Global.get_pieces()
	
	for piece in pieces:
		var new_colour = Global.get_tile_at_pos(piece.position).colour
		
		#fix, as the piece isn't on the tile yet (moving)
		if piece == trigger_piece: 
			piece.set_colour(colour)
			continue
		
		if new_colour != piece.colour:
			piece.set_colour(new_colour)
