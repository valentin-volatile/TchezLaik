extends Node2D

func _ready():
	var dir_path = "res://scenes/levels/chess_world/chapter_1/"
	var dir = DirAccess.open(dir_path)
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name:
		print(dir_path + file_name)
		file_name = dir.get_next()
