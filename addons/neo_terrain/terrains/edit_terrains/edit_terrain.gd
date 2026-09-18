@tool
extends ConfirmationDialog

@export var name_edit: LineEdit
@export var icon_edit: EditorResourcePicker
@export var id_edit: LineEdit

func _ready() -> void:
	if NeoTerrainGlobals.dock.current_entry != null:
		name_edit.text = NeoTerrainGlobals.dock.current_entry.entry_name
		icon_edit.edited_resource = NeoTerrainGlobals.dock.current_entry.get_child(0).texture
		id_edit.text = NeoTerrainGlobals.dock.current_entry.terrain_id

func _on_confirmed() -> void:
	if name_edit.text.is_empty():
		show_alert_dialog("Name cannot be empty")
		return
	elif id_edit.text.is_empty():
		show_alert_dialog("ID cannot be empty")
		return
	elif name_edit.text.is_empty() and id_edit.text.is_empty():
		show_alert_dialog("ID and name cannot be empty")
		return
		
	var dock = NeoTerrainGlobals.dock
	
	for terrain in dock.terrain_data.terrains:
		var id = terrain["terrain_id"]
		if id_edit.text == id and not id == dock.current_entry.terrain_id:
			show_alert_dialog("This ID already use")
			return
	
	var entry = NeoTerrainGlobals.dock.current_entry
	
	if icon_edit.edited_resource != null:
		entry.get_child(0).texture =  icon_edit.edited_resource
		
	entry.get_child(1).text = name_edit.text
	entry.terrain_id = id_edit.text
	entry.entry_name = name_edit.text
	
	NeoTerrainGlobals.dock.terrain_data.terrains[entry.get_index()]["name"] = name_edit.text
	if icon_edit.edited_resource != null:
		NeoTerrainGlobals.dock.terrain_data.terrains[entry.get_index()]["texture"] = icon_edit.edited_resource
	NeoTerrainGlobals.dock.terrain_data.terrains[entry.get_index()]["terrain_id"] = id_edit.text
	
	dock.terrain_data.terrains.sort_custom(func(a, b):
		return a["name"].nocasecmp_to(b["name"]) < 0
	)
	
	dock.update_entries()
	dock.current_entry = entry

func show_alert_dialog(dialog_text: String) -> void:
	var dialog = AcceptDialog.new()
	dialog.dialog_text = dialog_text
	EditorInterface.popup_dialog_centered(dialog)
	await dialog.visibility_changed
	dialog.queue_free()
