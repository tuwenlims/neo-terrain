@tool
extends ConfirmationDialog

var container: Container

@onready var name_edit: LineEdit = $GridContainer/NameEdit
@onready var icon_edit: EditorResourcePicker = $GridContainer/IconEdit
@onready var button_group: ButtonGroup = preload("res://addons/neo_terrain/entry/entry_button_group.tres")
@onready var id_edit: LineEdit = $GridContainer/IDEdit
@export var base_icon: Texture2D

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
		
	for terrain in dock.terrain_data.terrains:
		var id = terrain["terrain_id"]
		if id_edit.text == id:
			var dialog = AcceptDialog.new()
			dialog.dialog_text = "This ID already use"
			EditorInterface.popup_dialog_centered(dialog)
			await dialog.visibility_changed
			dialog.queue_free()
			return

	var entry = load("res://addons/neo_terrain/entry/entry.tscn").instantiate()
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
	
	dock.refresh_interface()
	entry._on_pressed()
