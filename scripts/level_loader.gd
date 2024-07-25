extends Node2D

var current_level_str: String = "res://scenes/levels/chapter_1/Level_1.tscn"
var current_chapter_str: String = "res://scenes/levels/chapter_1"

var current_level: Level
var current_level_index: int = -1
var level_data = {}


func _ready():
	level_data = SaverLoader.level_data
	next_level()


func _process(_delta):
	if Input.is_action_just_pressed("next_level"):
		next_level()
		
	if Input.is_action_just_pressed("previous_level"):
		previous_level()

	if Input.is_action_just_pressed("restart"): 
		restart_level()


func load_level(level_path: String) -> void:
	var new_level = load(level_path)
	new_level = new_level.instantiate()
	
	if current_level:
		current_level.queue_free()
		
	add_child(new_level)
	current_level = new_level
	current_level.solved.connect(set_solved)
	

func restart_level() -> void: 
	load_level(current_chapter_str + "/" + current_level_str)


func previous_level() -> void:
	var new_index = current_level_index - 1
	
	if new_index >= 0:
		current_level_index = new_index
		current_level_str = level_data[current_chapter_str].keys()[current_level_index]
		load_level(current_chapter_str + "/" + current_level_str)
	else:
		print("Already at the first level")


func next_level() -> void:
	var new_index = current_level_index + 1
	
	if new_index < level_data[current_chapter_str].size():
		current_level_index = new_index
		current_level_str = level_data[current_chapter_str].keys()[current_level_index]
		load_level(current_chapter_str + "/" + current_level_str)
	else:
		print("Already at the last level")

func set_solved() -> void:
	SaverLoader.update_level_data(current_chapter_str, current_level_str, true)
