@tool
extends Control

@export_group("Scenes")
@export var entry_scene: PackedScene
@export var create_window: PackedScene
@export var edit_window: PackedScene


@export_group("Nodes")
@export var flow_container: FlowContainer 
@export var colors_container: VBoxContainer

@export var workspace: Control 
@export var no_terrain_text: RichTextLabel 

@export var head_text: RichTextLabel 
@export var unique_id_text: RichTextLabel 


@export_group("Resources")
@export var button_group: ButtonGroup

var terrain_data = NeoTerrainGlobals.current_terrain_set
var current_entry: Control

signal update_overlay
signal force_show_terrains 

var sort_rule: Callable = func(a, b):
	var name_a = a.entry_name
	var name_b = b.entry_name
	
	return name_a.nocasecmp_to(name_b) < 0

func _ready() -> void:
	# Toolbar
	$VBoxContainer/ToolbarContainer/HBoxContainer/DrawButton.icon = get_theme_icon("Edit", "EditorIcons")
	$VBoxContainer/ToolbarContainer/HBoxContainer/LineButton.icon = get_theme_icon("Line", "EditorIcons")
	$VBoxContainer/ToolbarContainer/HBoxContainer/RestangleButton.icon = get_theme_icon("Rectangle", "EditorIcons")
	$VBoxContainer/ToolbarContainer/HBoxContainer/FillButton.icon = get_theme_icon("Bucket", "EditorIcons")
	$VBoxContainer/ToolbarContainer/HBoxContainer/EraserButton.icon = get_theme_icon("Eraser", "EditorIcons")
	$VBoxContainer/ToolbarContainer/HBoxContainer/ColorPickerButton.icon = get_theme_icon("ColorPick", "EditorIcons")
	$VBoxContainer/ToolbarContainer/HBoxContainer/RotateLeftButton.icon = get_theme_icon("RotateLeft", "EditorIcons")
	$VBoxContainer/ToolbarContainer/HBoxContainer/RotateRightButton.icon = get_theme_icon("RotateRight", "EditorIcons")
	$VBoxContainer/ToolbarContainer/HBoxContainer/HFlipButton.icon = get_theme_icon("MirrorX", "EditorIcons")
	$VBoxContainer/ToolbarContainer/HBoxContainer/VFlipButton.icon = get_theme_icon("MirrorY", "EditorIcons")
	
	# Lower Toolbar
	$VBoxContainer/HSplitContainer/LeftWindowContainer/LowerToolbarContainer/HBoxContainer/AddButton.icon = get_theme_icon("Add", "EditorIcons")
	$VBoxContainer/HSplitContainer/LeftWindowContainer/LowerToolbarContainer/HBoxContainer/EditButton.icon = get_theme_icon("Tools", "EditorIcons")
	$VBoxContainer/HSplitContainer/LeftWindowContainer/LowerToolbarContainer/HBoxContainer/DeleteButton.icon = get_theme_icon("Remove", "EditorIcons")
	$VBoxContainer/HSplitContainer/LeftWindowContainer/LowerToolbarContainer/HBoxContainer/SearchLine.right_icon = get_theme_icon("Search", "EditorIcons")
	
	$VBoxContainer/HSplitContainer/RightWindowPanel/Workspace/SettingsPanel/ScrollContainer/VBoxContainer/ColorsContainer/AddColorButton.icon = get_theme_icon("Add", "EditorIcons")
	$VBoxContainer/HSplitContainer/RightWindowPanel/Workspace/HeadText/AddNewTileMapButton.icon = get_theme_icon("Add", "EditorIcons")
	
	if current_entry == null:
		workspace.hide()
		no_terrain_text.show()
		
func update_entries() -> void:
	for child in flow_container.get_children():
		child.queue_free()
		
	for data in terrain_data.terrains:
		var entry = entry_scene.instantiate()
		entry.get_child(1).text = data["name"]
		if data["texture"] != null:
			entry.get_child(0).texture = data["texture"]
			
		entry.colors = data["colors"]
		entry.entry_name = data["name"]
		entry.terrain_id = data["terrain_id"]
		entry.new_color_number = data["new_color_number"]
		entry.unique_id = data["unique_id"]
		
		flow_container.add_child(entry)
		entry.button_group = button_group
		
	current_entry = null
	workspace.hide()
	no_terrain_text.show()
	
func _on_add_button_pressed() -> void:
	var popup = create_window.instantiate()
	popup.container = flow_container
	EditorInterface.popup_dialog_centered(popup)

func _on_edit_button_pressed() -> void:
	if current_entry != null:
		var popup = edit_window.instantiate()
		EditorInterface.popup_dialog_centered(popup)
		
func _on_delete_button_pressed() -> void:
	if current_entry != null:
		var popup = ConfirmationDialog.new()
		popup.dialog_text = "Are you sure?"
		EditorInterface.popup_dialog_centered(popup)
		await popup.confirmed
		
		terrain_data.terrains.remove_at(current_entry.get_index())
		
		current_entry.queue_free()
		current_entry = null
		workspace.hide()
		no_terrain_text.show()
		
		if terrain_data.terrains.size() == 0:
			terrain_data.new_unique_id = 0

func _on_search_line_text_changed(new_text: String) -> void:
	var text = new_text.strip_edges()
	
	if text .is_empty():
		for terrain in flow_container.get_children():
			terrain.show()
		return
	
	for terrain in flow_container.get_children():
		if terrain.entry_name.findn(text) != -1:
			terrain.show()
		else:
			terrain.hide()
			
func canvas_mouse_exit() -> void:
	pass

func about_to_be_visible(is_visible: bool) -> void:
	pass
