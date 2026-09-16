@tool
extends Container

@onready var color: PackedScene = preload("res://addons/neo_terrain/colors/color.tscn")
@onready var button_group: ButtonGroup = preload("res://addons/neo_terrain/colors/colors_button_group.tres")

func _on_add_color_button_pressed() -> void:
	var current_entry = NeoTerrainGlobals.dock.current_entry
	
	var new_color_name
	if current_entry.new_color_number == 0:
		new_color_name = "Color"
		current_entry.new_color_number += 1
	else:
		new_color_name = "Color" + str(current_entry.new_color_number)
		current_entry.new_color_number += 1
	
	var spawned_color = color.instantiate()
	var rand_color = Color(randf(), randf(), randf())
	spawned_color.update_color(rand_color)
	spawned_color.button_group = button_group
	add_child(spawned_color)
	spawned_color.text = new_color_name
	spawned_color.color_name = new_color_name
	
	var terrains: Array[String]
	
	var new_color: Dictionary = {
		"color_name": spawned_color.color_name,
		"default_color": spawned_color.default_color,
		"darker_color": spawned_color.darker_color,
		"lighter_color": spawned_color.lighter_color,
		"terrains": terrains
	}
	
	current_entry.colors.append(new_color)
	
	var terrain_index = current_entry.get_index()
	NeoTerrainGlobals.dock.terrain_data.terrains[terrain_index]["new_color_number"] = current_entry.new_color_number
	NeoTerrainGlobals.dock.terrain_data.terrains[terrain_index]["colors"] = current_entry.colors
