@tool
extends Button

var id: int

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		NeoTerrainGlobals.dock.add_texture(id)
