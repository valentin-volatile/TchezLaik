extends Node

var saved_data = ConfigFile.new()
var chapters_path= "res://scenes/levels/"
var save_path = "user://saved_data.cfg"
# used by level-loader to load levels
var level_data = {}


func _init():
	var err = saved_data.load(save_path)
	
	if err != OK:
		create_save_data()
	
	level_data = saved_data.get_value("level_data", "clear_status")
	
	
func create_save_data() -> void:
	var clear_status = {}
	var dir = DirAccess
	var chapters = dir.get_directories_at(chapters_path)
	
	
	for chapter in chapters:
		var complete_path: String = chapters_path + chapter
		clear_status[complete_path] = {}
		
		var levels = Array(dir.get_files_at(complete_path))
		
		for level in levels:
			clear_status[complete_path][level] = false
	
	saved_data.set_value("level_data", "clear_status", clear_status)
	saved_data.save(save_path)


func update_level_data(chapter: String, level: String, value: bool) -> void:
	level_data[chapter][level] = value
	saved_data.set_value("level_data", "clear_status", level_data)
	saved_data.save(save_path)


func load_data() -> void:
	pass


func was_level_completed(chapter: String, level: String) -> bool:
	return level_data[chapter][level]
