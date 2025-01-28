extends Node2D
class_name Board

@export var islands: Array[Island] = []
@export var island_scene: PackedScene = preload("res://scenes/island.tscn")
@export var totem_scene: PackedScene = preload("res://scenes/totem.tscn")

var island_shape: Array = [
	[0, 0, 1, 1, 0, 0],
	[0, 1, 1, 1, 1, 0],
	[1, 1, 1, 1, 1, 1],
	[1, 1, 1, 1, 1, 1],
	[0, 1, 1, 1, 1, 0],
	[0, 0, 1, 1, 0, 0],
]

const adjacent_offsets: Array = [
	[-1, 0], 	# Top middle
	[0, -1], 	# Middle left
	[0, 1], 	# Middle right
	[1, 0], 	# Bottom middle
]

const diagonal_offsets: Array = [
	[-1, -1],	# Top left
	[-1, 1], 	# Top right
	[1, -1], 	# Bottom left
	[1, 1]		# Bottom right
]

var flood_deck: Array[Island] = []
var flood_discard: Array[Island] = []

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
				island.row = row_idx
				island.col = col_idx
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
		
func generate_flood_deck() -> Array[Island]:
	flood_deck = get_islands().duplicate()
	flood_deck.shuffle()
	flood_discard.resize(0)
	return flood_deck
	
func get_flood_next() -> Island:
	if flood_deck.size() == 0:
		flood_deck = flood_discard
		flood_deck.shuffle()
		flood_discard.resize(0)
	var island_to_flood = flood_deck.pop_front()
	flood_discard.append(island_to_flood)
	return island_to_flood

		
func get_spawn_tiles_for_class(clazz: Classes.Class) -> Array[Island]:
	return get_islands().filter(func(island: Island): return island.spawned_player == clazz)
	
func get_island_by_row_col(row: int, col: int) -> Island:
	return get_islands().filter(func(island: Island): return island.row == row and island.col == col)[0]

func get_adjacent_tiles_for_player(player: Player):
	var adjacent_tiles: Array[Island] = []
	var island = player.current_tile	
	var offsets = adjacent_offsets.duplicate()

	if player.special_action == Classes.SpecialAction.MOVE_SHORE_UP_DIAG:
		for offset in diagonal_offsets:
			offsets.append(offset)
		
	for offset in offsets:
		var adj_row = island.row + offset[0]
		var adj_col = island.col + offset[1]
		if (adj_row >= 0 and adj_row < island_shape.size() and
			adj_col >= 0 and adj_col < island_shape[0].size()):
			if island_shape[adj_row][adj_col] > 0:
				adjacent_tiles.append(get_island_by_row_col(adj_row, adj_col))
	
	return adjacent_tiles

func flood(island: Island, state: bool):
	if island.flooded and state:
		print("Island removed")
		island.queue_free()
	else:
		island.flooded = state
		if state:
			flood_discard.append(island)
