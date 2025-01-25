extends Node2D
class_name Board

@export var islands: Array[Island] = []
@export var island_scene: PackedScene = preload("res://scenes/island.tscn")
@export var totem_scene: PackedScene = preload("res://scenes/totem.tscn")

const island_shape: Array = [
	[0, 0, 1, 1, 0, 0],
	[0, 1, 1, 1, 1, 0],
	[1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1],
	[0, 1, 1, 1, 1, 0],
	[0, 0, 1, 1, 0, 0],
]

func count_island_tiles() -> int:
	var count = 0
	for row in island_shape:
		for cell in row:
			if cell == 1:
				count += 1
	return count
	
func get_islands() -> Array[Island]:
	return islands

func generate_island() -> void:
	var island_resources = Util.load_all_resources_in_dir("res://resources/island/") as Array[IslandResource]
	var island_count = count_island_tiles()
	assert(island_resources.size() >= island_count, "res://resources/island/ must have at least %d resources!" % island_count)
	
	var final_resources: Array[IslandResource]
	var opt_resources: Array[IslandResource]
	for resource in island_resources:
		if resource.always_spawn:
			final_resources.append(resource)
		else:
			opt_resources.append(resource)
			
	# Fill in remaining islands from opt_resources
	opt_resources.shuffle()
	for i in range(island_count - final_resources.size()):
		final_resources.append(opt_resources[i])
	
	final_resources.shuffle()

	# Spawn islands
	for resource in final_resources:
		var new_island = island_scene.instantiate() as Island
		add_child(new_island)
		new_island.resource = resource
		islands.append(new_island)
		
	# Position islands
	var island_idx = 0
	for row_idx in range(island_shape.size()):
		for col_idx in range(island_shape[row_idx].size()):
			var cell = island_shape[row_idx][col_idx]
			if cell > 0:
				# Place island here
				var island = islands[island_idx]
				island.position = Vector2(col_idx * 200, row_idx * 200)
				island_idx += 1

	# Spawn totems
	var extents = Util.get_extents(get_islands())
	
	var totem_resources = Util.load_all_resources_in_dir("res://resources/totem/") as Array[TotemResource]
	
	var totem_positions = [
		extents.position,
		extents.position + Vector2(extents.size.x, 0),
		extents.position + extents.size,
		extents.position + Vector2(0, extents.size.y)
	]
	
	if totem_resources.size() != totem_positions.size():
		print("Totem amount mismatch with totem positions")
		
	for i in range(totem_resources.size()):
		var new_totem = totem_scene.instantiate() as Totem
		add_child(new_totem)
		new_totem.resource = totem_resources[i]
		new_totem.position = totem_positions[i]
		
func get_spawn_tiles_for_class(clazz: Classes.Class) -> Array[Island]:
	return get_islands().filter(func(island: Island): return island.spawned_player == clazz)
