extends CanvasLayer


@export var base_colour: Color
@export var pattern_colour: Color
@export var added_dimness: Color

@onready var base = $Base
@onready var pattern = $Pattern

var width: int = 1920
var height: int = 1080


func initializate() -> void:
	set_palette()
	base.size = Vector2(width, height)
	pattern.size = Vector2(width, height)
	visible = true


func set_palette():
	base.color = base_colour - added_dimness
	pattern.modulate = pattern_colour - added_dimness
