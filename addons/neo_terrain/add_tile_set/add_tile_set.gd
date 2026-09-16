@tool
extends AcceptDialog

@onready var flow_container: FlowContainer = $ScrollContainer/FlowContainer
@onready var add_texture_button_group: ButtonGroup = preload("res://addons/neo_terrain/add_tile_set/add_texture_button_group.tres")


func _ready() -> void:
	var tile_set: TileSet = NeoTerrainGlobals.current_tile_set
	
	for i in range(tile_set.get_source_count()):
		var source = tile_set.get_source(tile_set.get_source_id(i))
		
		var tile_map = NeoTerrainGlobals.current_tile_map
			
		if source is TileSetAtlasSource:
			var texture = source.texture
			var name = texture.resource_path.get_file()
			
			var entry = preload("res://addons/neo_terrain/add_tile_set/entry.tscn").instantiate()
			entry.get_child(0).texture = texture
			entry.get_child(1).text = name
			entry.id = tile_set.get_source_id(i)
			entry.button_group = add_texture_button_group
			flow_container.add_child(entry)
