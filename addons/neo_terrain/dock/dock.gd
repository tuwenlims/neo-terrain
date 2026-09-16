@tool
extends Control

const DATA_PATH = "res://addons/neo_terrain/terrain_storage.tres"
var terrain_data = NeoTerrainGlobals.current_terrain_set

var undo_manager: EditorUndoRedoManager

var current_entry: Control


@onready var colors_container: VBoxContainer = $VBoxContainer/HSplitContainer/Panel/Workspace/SettingsPanel/ScrollContainer/VBoxContainer/ColorsContainer
@onready var workspace: Control = $VBoxContainer/HSplitContainer/Panel/Workspace
@onready var no_terrain_text: RichTextLabel = $VBoxContainer/HSplitContainer/Panel/NoTerrainText
@onready var head_text: RichTextLabel = $VBoxContainer/HSplitContainer/Panel/Workspace/SettingsPanel/HeadText
@onready var unique_id_text: RichTextLabel = $VBoxContainer/HSplitContainer/Panel/Workspace/SettingsPanel/UniqueIDText

@export var flow_container: FlowContainer 
@export var button_group: ButtonGroup

signal update_overlay
signal force_show_terrains 

var sort_rule: Callable = func(a, b):
	var name_a = a.entry_name
	var name_b = b.entry_name
	
	return name_a.nocasecmp_to(name_b) < 0

func _ready() -> void:
	# Toolbar
	$VBoxContainer/HBoxContainer/DrawButton.icon = get_theme_icon("Edit", "EditorIcons")
	$VBoxContainer/HBoxContainer/LineButton.icon = get_theme_icon("Line", "EditorIcons")
	$VBoxContainer/HBoxContainer/RestangleButton.icon = get_theme_icon("Rectangle", "EditorIcons")
	$VBoxContainer/HBoxContainer/FillButton.icon = get_theme_icon("Bucket", "EditorIcons")
	$VBoxContainer/HBoxContainer/EraserButton.icon = get_theme_icon("Eraser", "EditorIcons")
	$VBoxContainer/HBoxContainer/ColorPickerButton.icon = get_theme_icon("ColorPick", "EditorIcons")
	$VBoxContainer/HBoxContainer/RotateLeftButton.icon = get_theme_icon("RotateLeft", "EditorIcons")
	$VBoxContainer/HBoxContainer/RotateRightButton.icon = get_theme_icon("RotateRight", "EditorIcons")
	$VBoxContainer/HBoxContainer/HFlipButton.icon = get_theme_icon("MirrorX", "EditorIcons")
	$VBoxContainer/HBoxContainer/VFlipButton.icon = get_theme_icon("MirrorY", "EditorIcons")
	
	# Lower Toolbar
	$VBoxContainer/HSplitContainer/VBoxContainer/LowerToolbar/AddButton.icon = get_theme_icon("Add", "EditorIcons")
	$VBoxContainer/HSplitContainer/VBoxContainer/LowerToolbar/EditButton.icon = get_theme_icon("Tools", "EditorIcons")
	$VBoxContainer/HSplitContainer/VBoxContainer/LowerToolbar/DeleteButton.icon = get_theme_icon("Remove", "EditorIcons")
	
	$VBoxContainer/HSplitContainer/Panel/Workspace/SettingsPanel/ScrollContainer/VBoxContainer/ColorsContainer/AddColorButton.icon = get_theme_icon("Add", "EditorIcons")
	$VBoxContainer/HSplitContainer/Panel/Workspace/SettingsPanel/AddNewTexture.icon = get_theme_icon("Add", "EditorIcons")
	
	$VBoxContainer/HSplitContainer/Panel/Workspace/AddTextureButton.icon = get_theme_icon("Add", "EditorIcons")
	
	if current_entry == null:
		workspace.hide()
		no_terrain_text.show()
		
func refresh_interface() -> void:
	for child in flow_container.get_children():
		child.queue_free()
		
	for data in terrain_data.terrains:
		var entry = load("res://addons/neo_terrain/entry/entry.tscn").instantiate()
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

func canvas_mouse_exit() -> void:
	pass

func about_to_be_visible(is_visible: bool) -> void:
	pass
	
func _on_add_button_pressed() -> void:
	var popup = preload("res://addons/neo_terrain/entry/create_window.tscn").instantiate()
	popup.container = flow_container
	EditorInterface.popup_dialog_centered(popup)

func _on_edit_button_pressed() -> void:
	if current_entry != null:
		var popup = preload("res://addons/neo_terrain/entry/edit_window.tscn").instantiate()
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


func _on_add_texture_button_pressed() -> void:
		var popup = preload("res://addons/neo_terrain/add_tile_set/add_tile_set.tscn").instantiate()
		EditorInterface.popup_dialog_centered(popup)
