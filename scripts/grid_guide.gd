@tool
extends TextureRect

func _ready():
	size = Vector2(get_parent().columns*Global.TILE_SIZE, get_parent().rows*Global.TILE_SIZE )
