@tool
extends Button

var entry_name: String
var terrain_id: String
var unique_id: int

var new_color_number: int

var colors: Array[Dictionary]

func _on_pressed() -> void:
	NeoTerrainGlobals.dock.current_entry = self
	NeoTerrainGlobals.dock.head_text.text = entry_name + " (" + terrain_id + ")"
	NeoTerrainGlobals.dock.unique_id_text.text = "Unique ID: " + str(unique_id)
	for child in NeoTerrainGlobals.dock.colors_container.get_children():
		if child.name != "AddColorButton":
			child.queue_free()
			
		
	for color_data in colors:
		var spawned_color = load("res://addons/neo_terrain/colors/color.tscn").instantiate()
		NeoTerrainGlobals.dock.colors_container.add_child(spawned_color)
		spawned_color.color_name = color_data.color_name
		spawned_color.text = color_data.color_name
		spawned_color.update_color(color_data.default_color)
		spawned_color.terrains =  color_data.terrains
		
	

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		NeoTerrainGlobals.dock.workspace.show()
		NeoTerrainGlobals.dock.no_terrain_text.hide()
	else:
		NeoTerrainGlobals.dock.workspace.hide()
		NeoTerrainGlobals.dock.no_terrain_text.show()
