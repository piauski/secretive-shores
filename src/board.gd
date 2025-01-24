extends Node2D
class_name Board

@export var island_tiles: Array
@export var island_scene: PackedScene = preload("res://island.tscn")
@export var totem_scene: PackedScene = preload("res://totem.tscn")

const island_shape: Array = [
	[0, 0, 1, 1, 0, 0],
	[0, 1, 1, 1, 1, 0],
	[1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1],
	[0, 1, 1, 1, 1, 0],
	[0, 0, 1, 1, 0, 0],
]

const spawn_types = {
	Classes.Class.DIVER: Tiles.Tile.SPAWN_DIVER,
	Classes.Class.ENGINEER: Tiles.Tile.SPAWN_ENGINEER,
	Classes.Class.NAVIGATOR: Tiles.Tile.SPAWN_NAVIGATOR,
	Classes.Class.PILOT: Tiles.Tile.SPAWN_PILOT,
	Classes.Class.EXPLORER: Tiles.Tile.SPAWN_EXPLORER,
	Classes.Class.MESSENGER: Tiles.Tile.SPAWN_MESSENGER,
}

func count_island_tiles() -> int:
	var count = 0
	for row in island_shape:
		for cell in row:
			if cell == 1:
				count += 1
	return count


func generate_island() -> void:
	# Generate random tiles, fill empties with GENERIC.  This ensures
	# every tile in Tiles.tile_types is present at least once, with
	# every other tile being GENERIC.
	var random_tile_types = Tiles.tile_types.duplicate()
	random_tile_types.resize(count_island_tiles())
	for i in range(random_tile_types.size()):
		if random_tile_types[i] == null:
			random_tile_types[i] = Tiles.Tile.GENERIC
	random_tile_types.shuffle()

	# Turn island shape into array of tiles
	island_tiles = []
	for row in island_shape:
		var new_row = []
		for cell in row:
			if cell == 1:
				new_row.append(random_tile_types.pop_front())
			else:
				new_row.append(Tiles.Tile.NONE)
		island_tiles.append(new_row)

	# Generate random tile names for generic tiles
	var tile_names: Dictionary
	for tile_type in Tiles.tile_data.keys():
		tile_names[tile_type] = Tiles.tile_data[tile_type].names.duplicate()
		tile_names[tile_type].shuffle()

	# Spawn Island Tiles
	for row_index in range(island_tiles.size()):
		for cell_index in range(island_tiles[row_index].size()):
			var cell = island_tiles[row_index][cell_index]
			if cell != 0:
				var island_instance = island_scene.instantiate()
				island_instance.position = Vector2(cell_index * 200, row_index * 200)
				island_instance.island_type = cell
				# FIXME: this assumes every cell apart from GENERIC has the same name.
				var island_name = tile_names[cell].pop_front() if cell == Tiles.Tile.GENERIC else tile_names[cell][0]
				island_instance.set_name(island_name)
				island_instance.island_name = island_name
				add_child(island_instance)
				island_instance.flooded = false
				print("spawned island ", island_instance.name)
	
	var extents = get_extents(get_islands())
	
	var totem_instance = totem_scene.instantiate()
	totem_instance.position = extents.position + Vector2(100,100)
	add_child(totem_instance)
	
	totem_instance = totem_scene.instantiate()
	totem_instance.position = extents.position + Vector2(extents.size.x,0) + Vector2(-100,100)
	add_child(totem_instance)
	
	totem_instance = totem_scene.instantiate()
	totem_instance.position = extents.position + Vector2(0,extents.size.y) + Vector2(100,-100)
	add_child(totem_instance)
	
	totem_instance = totem_scene.instantiate()
	totem_instance.position = extents.position + Vector2(extents.size.x, extents.size.y) + Vector2(-100,-100)
	add_child(totem_instance)
		
	
	
func get_islands() -> Array[Island]:
	var islands: Array[Island]
	for node in get_children():
		if node is Island:
			islands.append(node)
	return islands
	
func get_extents(islands: Array[Island]):
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF
	for island in islands:
		var but = island.get_node("Button")
		var global_rect = but.get_global_rect()
		min_x = min(min_x, global_rect.position.x)
		min_y = min(min_y, global_rect.position.y)
		max_x = max(max_x, global_rect.position.x + global_rect.size.x)
		max_y = max(max_y, global_rect.position.y + global_rect.size.y)
	return Rect2(min_x, min_y, max_x - min_x, max_y - min_y)
		
func get_spawn_tile_for_class(clazz: Classes.Class) -> Island:
	return get_islands().filter(func(island:Island): return island.island_type == spawn_types[clazz])[0]
