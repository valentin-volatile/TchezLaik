extends TileOnStep

@export var piece_path: PackedScene

func _on_step(trigger_piece: Piece) -> void:
	if not activation_amount: return
	activation_amount -= 1;
	
	await trigger_piece.finished_animation
	
	var new_piece: Piece = piece_path.instantiate()
	
	new_piece.position = position
	
	trigger_piece.disappear()
	await trigger_piece.finished_animation
	
	Global.grid_node.add_piece(new_piece)
	new_piece.set_colour(trigger_piece.colour)

