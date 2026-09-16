@tool
extends AcceptDialog
class_name SelectTerrains

@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var entry_scene: PackedScene = load("res://addons/neo_terrain/select_terrain/entry.tscn")

@onready var enable_all_button: Button = $ScrollContainer/VBoxContainer/EnableAllButton
@onready var disable_all_button: Button = $ScrollContainer/VBoxContainer/DisableAllButton

var current_color: TerrainColor

func _ready() -> void:
	for terrain in NeoTerrainGlobals.current_terrain_set.terrains:
		var spawned_entry = entry_scene.instantiate()
		spawned_entry.select_terrains = self
		
		spawned_entry.id = terrain.terrain_id
		spawned_entry.get_child(0).text = terrain.name + " (" + terrain.terrain_id + ")"
		spawned_entry.get_child(0).icon = terrain.texture
		
		if terrain.terrain_id in current_color.terrains:
			spawned_entry.get_child(0).button_pressed = true
			
		v_box_container.add_child(spawned_entry)
		
func enable_terrain(id: String) -> void:
	if not id in current_color.terrains:
		current_color.terrains.append(id)
		
		var index = current_color.get_index() - 1
		NeoTerrainGlobals.dock.current_entry.colors[index]["terrains"] = current_color.terrains
	
func disable_terrain(id: String) -> void:
	var index = current_color.terrains.find(id)
	current_color.terrains.remove_at(index)
	
func _on_enable_all_button_pressed() -> void:
	for entry in v_box_container.get_children():
		if entry in [enable_all_button, disable_all_button]:
			continue
	
		entry.set_pressed(true)

func _on_disable_all_button_pressed() -> void:
	for entry in v_box_container.get_children():
		if entry in [enable_all_button, disable_all_button]:
			continue
			
		entry.set_pressed(false)
