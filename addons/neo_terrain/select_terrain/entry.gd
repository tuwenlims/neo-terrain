@tool
extends Control

var select_terrains: SelectTerrains
var id: String

func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		select_terrains.enable_terrain(id)
	else:
		select_terrains.disable_terrain(id)
		
func set_pressed(value: bool) -> void:
	var button = $CheckButton
	if button.button_pressed != value:
		button.button_pressed = value
