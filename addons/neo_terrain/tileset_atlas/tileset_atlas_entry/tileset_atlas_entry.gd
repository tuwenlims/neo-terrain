@tool
extends Panel

func _ready() -> void:
	$VBoxContainer/PanelContainer/ButtonsContainer/OpenEditorButton.icon = get_theme_icon("Tools", "EditorIcons")
	$VBoxContainer/PanelContainer/ButtonsContainer/RemoveButton.icon = get_theme_icon("Remove", "EditorIcons")
