extends Node2D

var current_level: Level
var current_level_index: int = -1
var level_array: Array

func _ready():
	populate_level_array()
	next_level()


func _process(_delta):
	if Input.is_action_just_pressed("next_level"):
		next_level()
		
	if Input.is_action_just_pressed("previous_level"):
		previous_level()

	if Input.is_action_just_pressed("restart"): 
		restart_level()


func populate_level_array() -> void:
	var dir_path = "res://scenes/levels/chapter_3/"
	var dir = DirAccess.open(dir_path)
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name:
		level_array.append(dir_path + file_name)
		file_name = dir.get_next()
	print(level_array)


func load_level(level_path: String) -> void:
	var new_level = load(level_path)
	new_level = new_level.instantiate()
	
	if current_level:
		current_level.queue_free()
	add_child(new_level)
	current_level = new_level


func restart_level() -> void: 
	load_level(level_array[current_level_index])


func previous_level() -> void:
	var new_index = current_level_index - 1
	
	if new_index >= 0:
		current_level_index = new_index
		load_level(level_array[current_level_index])
	else:
		print("Already at the first level")


func next_level() -> void:
	var new_index = current_level_index + 1
	
	if new_index < level_array.size():
		current_level_index = new_index
		load_level(level_array[current_level_index])
	else:
		print("Already at the last level")
