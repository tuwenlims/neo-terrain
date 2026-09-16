@tool
extends Button
class_name TerrainColor

var color_name: String

var default_color: Color 
var darker_color: Color 
var lighter_color: Color 

var terrains: Array[String]

func _ready() -> void:
	$DeleteButton.icon = get_theme_icon("Remove", "EditorIcons")
	$EditButton.icon = get_theme_icon("Tools", "EditorIcons")
	
func update_color(new_def_color: Color) -> void:
	default_color = new_def_color
	lighter_color = default_color.lightened(0.4)
	darker_color =  default_color.darkened(0.4)
	
	add_theme_color_override("icon_normal_color", default_color)
	add_theme_color_override("icon_focus_color", lighter_color)
	add_theme_color_override("icon_pressed_color", darker_color)
	add_theme_color_override("icon_hover_color", lighter_color)
	add_theme_color_override("icon_hover_pressed_color", darker_color)
	

func _on_delete_button_pressed() -> void:
	var terrain_index = NeoTerrainGlobals.dock.current_entry.get_index()
	var color_index = get_index() - 1
	NeoTerrainGlobals.dock.terrain_data.terrains[terrain_index]["colors"].remove_at(color_index)
	
	if NeoTerrainGlobals.dock.terrain_data.terrains[terrain_index]["colors"].size() == 0:
		NeoTerrainGlobals.dock.current_entry.new_color_number = 0
	
	queue_free()

func _on_edit_button_pressed() -> void:
	var popup = preload("res://addons/neo_terrain/colors/edit_color.tscn").instantiate()
	popup.color = self
	EditorInterface.popup_dialog_centered(popup)
