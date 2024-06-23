extends Camera2D

@export var override_zoom: Vector2



func update_zoom():
	zoom = override_zoom if override_zoom else get_appropiate_zoom()


func get_appropiate_zoom() -> Vector2:
	var new_zoom: Vector2
	if Global.grid_rows <= 5:
		new_zoom = Vector2(1, 1)
	else:
		new_zoom = Vector2(0.5, 0.5)
	return new_zoom
