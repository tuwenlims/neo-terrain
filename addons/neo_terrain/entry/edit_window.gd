@tool
extends ConfirmationDialog

@onready var name_edit: LineEdit = $GridContainer/NameEdit
@onready var icon_edit: EditorResourcePicker = $GridContainer/IconEdit
@onready var id_edit: LineEdit = $GridContainer/IDEdit

func _ready() -> void:
	if NeoTerrainGlobals.dock.current_entry != null:
		name_edit.text = NeoTerrainGlobals.dock.current_entry.get_child(1).text
		icon_edit.edited_resource = NeoTerrainGlobals.dock.current_entry.get_child(0).texture
		id_edit.text = NeoTerrainGlobals.dock.current_entry.terrain_id

func _on_confirmed() -> void:
	if name_edit.text.is_empty():
		var dialog = AcceptDialog.new()
		dialog.dialog_text = "Name cannot be empty"
		EditorInterface.popup_dialog_centered(dialog)
		await dialog.visibility_changed
		dialog.queue_free()
		return
	elif id_edit.text.is_empty():
		var dialog = AcceptDialog.new()
		dialog.dialog_text = "ID cannot be empty"
		EditorInterface.popup_dialog_centered(dialog)
		await dialog.visibility_changed
		dialog.queue_free()
		return
	elif name_edit.text.is_empty() and id_edit.text.is_empty():
		var dialog = AcceptDialog.new()
		dialog.dialog_text = "ID and name cannot be empty"
		EditorInterface.popup_dialog_centered(dialog)
		await dialog.visibility_changed
		dialog.queue_free()
		return
	
	var dock = NeoTerrainGlobals.dock
	
	for i in range(dock.terrain_data.terrains.size()):
		var terrain = dock.terrain_data.terrains[i]
		var id = terrain["terrain_id"]
		if id_edit.text == id and i != dock.current_entry.get_index():
			var dialog = AcceptDialog.new()
			dialog.dialog_text = "This ID already use"
			EditorInterface.popup_dialog_centered(dialog)
			await dialog.visibility_changed
			dialog.queue_free()
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
	
	dock.refresh_interface()
	dock.current_entry = entry
