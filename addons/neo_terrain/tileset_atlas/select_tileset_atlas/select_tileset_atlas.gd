@tool
extends AcceptDialog

@export_group("Scenes")
@export var select_tileset_atlas_entry: PackedScene


@export_group("Nodes")
@export var v_box_container: VBoxContainer
@export var no_tileset_label: RichTextLabel


func _ready() -> void:
	var tileset = NeoTerrainGlobals.current_tile_set
		
	for source_index in range(tileset.get_source_count()):
		var source_id = tileset.get_source_id(source_index)
		var source = tileset.get_source(source_id)
		
		if source is TileSetAtlasSource:
			var atlas_source = source
			
			var texture = atlas_source.texture
			var file_name = texture.resource_path.get_file()
			
			var spawned_entry = select_tileset_atlas_entry.instantiate()
			spawned_entry.texture = texture
			spawned_entry.file_name = file_name
			spawned_entry.atlas_id = source_id
			v_box_container.add_child(spawned_entry)
			
	if v_box_container.get_children().is_empty():
		no_tileset_label.show()
			
