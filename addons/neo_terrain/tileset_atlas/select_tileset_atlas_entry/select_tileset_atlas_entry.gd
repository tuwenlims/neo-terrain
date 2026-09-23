@tool
extends Button

var file_name: String
var texture: Texture2D
var atlas_id: int

func _ready() -> void:
	text = file_name
	icon = texture

func _on_pressed() -> void:
	pass # Replace with function body.
