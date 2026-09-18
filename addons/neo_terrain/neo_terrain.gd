@tool
extends EditorPlugin

var dock_content: Control
var is_panel_added: bool = false

func _enter_tree() -> void:
	dock_content = preload("res://addons/neo_terrain/dock/dock_content.tscn").instantiate()
	NeoTerrainGlobals.dock = dock_content

func _exit_tree() -> void:
	if is_panel_added and dock_content:
		remove_control_from_bottom_panel(dock_content)
	if dock_content:
		dock_content.queue_free()

func _handles(object: Object) -> bool:
	if object is NeoTileMapLayer:
		NeoTerrainGlobals.current_terrain_set = object.terrain_set
		NeoTerrainGlobals.current_tile_set = object.tile_set
		NeoTerrainGlobals.current_tile_map = object
		
		dock_content.terrain_data = object.terrain_set
		dock_content.update_entries()
	return object is NeoTileMapLayer

func _edit(object: Object) -> void:
	update_overlays()
	
func _make_visible(visible: bool) -> void:
	if not dock_content: return
	
	if visible:
		if not is_panel_added:
			add_control_to_bottom_panel(dock_content, "NeoTerrain")
			is_panel_added = true
		make_bottom_panel_item_visible(dock_content)
	else:
		if is_panel_added:
			remove_control_from_bottom_panel(dock_content)
			is_panel_added = false
