@tool
extends ConfirmationDialog

@export_group("Scenes")
@export var entry_scene: PackedScene


@export_group("Nodes")
@export var name_edit: LineEdit
@export var icon_edit: EditorResourcePicker
@export var id_edit: LineEdit


@export_group("Resources")
@export var button_group: ButtonGroup
@export var base_icon: Texture2D

var container: Container

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

	var entry = entry_scene.instantiate()
	entry.button_group = button_group
	
	if icon_edit.edited_resource != null:
		entry.get_child(0).texture =  icon_edit.edited_resource
	entry.get_child(1).text = name_edit.text
	
	container.add_child(entry)
	
	entry.terrain_id = id_edit.text
	entry.entry_name = name_edit.text
	
	var new_terrain = {
			"name": name_edit.text,
			"texture": icon_edit.edited_resource if icon_edit.edited_resource != null else base_icon,
			"colors": entry.colors,
			"terrain_id": id_edit.text,
			"new_color_number": 0,
			"unique_id": dock.terrain_data.new_unique_id
		}
	
	dock.terrain_data.new_unique_id += 1
	dock.terrain_data.terrains.append(new_terrain)
	
	dock.terrain_data.terrains.sort_custom(func(a, b):
		return a["name"].nocasecmp_to(b["name"]) < 0
	)
	
	dock.update_entries()
	entry._on_pressed()
	
func show_alert_dialog(dialog_text: String) -> void:
	var dialog = AcceptDialog.new()
	dialog.dialog_text = dialog_text
	EditorInterface.popup_dialog_centered(dialog)
	await dialog.visibility_changed
	dialog.queue_free()
