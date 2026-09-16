@tool
extends ConfirmationDialog

var color
@onready var name_edit: LineEdit = $GridContainer/NameEdit
@onready var color_edit: ColorPickerButton = $GridContainer/ColorPickerButton


func _ready() -> void:
	name_edit.text = color.color_name
	color_edit.color = color.default_color
	
	$GridContainer/SelectTerrains.icon = get_theme_icon("Edit", "EditorIcons")

func _on_confirmed() -> void:
	if name_edit.text.is_empty():
		var dialog = AcceptDialog.new()
		dialog.dialog_text = "Name cannot be empty"
		EditorInterface.popup_dialog_centered(dialog)
		await dialog.visibility_changed
		dialog.queue_free()
		return
	
	var dock = NeoTerrainGlobals.dock
		
	for i in range(dock.current_entry.colors.size()):
		var cur_color = dock.current_entry.colors[i]
		var id = cur_color["color_name"]
		if name_edit.text == id and i != color.get_index() - 1:
			var dialog = AcceptDialog.new()
			dialog.dialog_text = "This name already use"
			EditorInterface.popup_dialog_centered(dialog)
			await dialog.visibility_changed
			dialog.queue_free()
			return
			
	color.color_name = name_edit.text
	color.text = name_edit.text
	color.update_color(color_edit.color)
	
	var index = color.get_index() - 1
	
	dock.current_entry.colors[index]["color_name"] = name_edit.text
	dock.current_entry.colors[index]["default_color"] = color.default_color
	dock.current_entry.colors[index]["lighter_color"] = color.lighter_color
	dock.current_entry.colors[index]["darker_color"] = color.darker_color


func _on_select_terrains_pressed() -> void:
	var popup = preload("res://addons/neo_terrain/select_terrain/select_terrains.tscn").instantiate()
	popup.current_color = color
	EditorInterface.popup_dialog_centered(popup)
