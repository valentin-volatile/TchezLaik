extends Node

var level_data = {}
var chapters_path= "res://scenes/levels/"
var save_path = "user://savegame.save"


func _init():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var dir = DirAccess
	var chapters = dir.get_directories_at(chapters_path)

	for chapter in chapters:
		var complete_path: String = chapters_path + chapter
		level_data[complete_path] = []
		
		var levels = Array(dir.get_files_at(complete_path))
		
		for level in levels:
			level_data[complete_path].append([complete_path + "/" + level, false])
	
	save_game.store_line(JSON.stringify(level_data))


func save_level_data() -> void:
	
	pass


func update_level_data(chapter: String, level: String, value: bool) -> void:
	
	pass


func load_data() -> void:
	pass


func was_level_completed(level: String) -> bool:
	return false
