extends TileOnStep

@export var piece_path: PackedScene

func _on_step(trigger_piece: Piece) -> void:
	if not activation_amount: return
	activation_amount -= 1;
	
	print(activation_amount)
	
	await trigger_piece.finished_animation
	
	play_promotion_anim()
	trigger_piece.disappear()
	
	await trigger_piece.finished_animation
	
	var new_piece: Piece = piece_path.instantiate()
	new_piece.position = position
	Global.grid_node.add_piece(new_piece)


func play_promotion_anim() -> void:
	pass
