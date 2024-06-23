extends Camera2D

@export var override_zoom: Vector2



func update_zoom():
	zoom = override_zoom if override_zoom else get_appropiate_zoom()


func get_appropiate_zoom() -> Vector2:
	var new_zoom: Vector2
	
	if Global.grid_rows <= 4:
		new_zoom = Vector2(1, 1)
	elif Global.grid_rows <= 7:
		new_zoom = Vector2(0.55, 0.55)
	else:
		new_zoom = Vector2(0.45, 0.45)
	return new_zoom
