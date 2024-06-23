extends CanvasLayer

@onready var main_container = $MainContainer
@onready var objective_texture: TextureRect = $MainContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/TextureRect

func _ready():
	pass

func update_sprite(piece: Piece) -> void:
	objective_texture.texture = piece.sprite.texture
	objective_texture.self_modulate = piece.modulate
