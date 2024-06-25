extends CanvasLayer

@onready var main_container = $MainContainer
@onready var move_counter: Label = $MainContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Moves

func _ready():
	pass

func update_counter(amount: int) -> void:
	move_counter.text = str(amount)
