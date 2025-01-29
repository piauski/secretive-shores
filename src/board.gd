class_name Board extends Node2D

# Signals
signal island_clicked(Island, Vector2)
signal clicked(Vector2)

# Export Variables
@export var islands: Array[Island] = []
@export var island_scene: PackedScene = preload("res://scenes/island.tscn")
@export var totem_scene: PackedScene = preload("res://scenes/totem.tscn")

# Local Variables
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
	[0, 0], 	# Middle -- Include own tile
	[0, 1], 	# Middle right
	[1, 0], 	# Bottom middle
]

const diagonal_offsets: Array = [
	[-1, -1],	# Top left
	[-1, 1], 	# Top right
	[1, -1], 	# Bottom left
	[1, 1]		# Bottom right
]

var flood_deck: Array[Vector2i] = []
var flood_discard: Array[Vector2i] = []
var flood_level: int = 0

func _input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			clicked.emit(get_global_mouse_position())
			var clicked_islands = raycast_check_for_island()
			if clicked_islands:
				island_clicked.emit(clicked_islands[0], get_global_mouse_position())
		else:
			pass
			
func raycast_check_for_island() -> Array[Island]:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var results = space_state.intersect_point(parameters).filter(func(result): return result.collider.get_parent() is Island)
	var found_islands: Array[Island] = []
	if results.size() > 0:
		for result in results:
			found_islands.append(result.collider.get_parent())
	return found_islands

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
		

func get_amount_of_flood_cards() -> int:
	match flood_level:
		0, 1, 2:
			return 2
		3, 4, 5, 6:
			return 3
		7, 8, 9:
			return 2
		_:
			return -1
			
func generate_flood_deck() -> Array[Vector2i]:
	for island in get_islands():
		flood_deck.append(Vector2i(island.row, island.col))
	flood_deck.shuffle()
	flood_discard.resize(0)
	return flood_deck
	
func reshuffle_flood_deck():
	for flooded in flood_discard:
		flood_deck.append(flooded)
	flood_discard.resize(0)
	flood_deck.shuffle()
		
func get_flood_next(force: bool = false) -> Vector2i:
	if flood_deck.size() <= 0 or force:
		reshuffle_flood_deck()
	var island_to_flood = flood_deck.pop_front()
	flood_discard.append(island_to_flood)
	return island_to_flood

		
func get_spawn_tiles_for_class(clazz: Classes.Class) -> Array[Island]:
	return get_islands().filter(func(island: Island): return island.spawned_player == clazz)
	
func get_island_by_row_col(row: int, col: int):
	var found_islands := get_islands().filter(func(island: Island): return island.row == row and island.col == col)
	if found_islands.size() > 0:
		return found_islands[0]
	else:
		return null
		
func get_island_by_pos(pos: Vector2i):
	var found_islands := get_islands().filter(func(island: Island): return island.pos == pos)
	if found_islands.size() > 0:
		return found_islands[0]
	else:
		return null

func get_adjacent_tiles_for_player(player: Player):
	var adjacent_tiles: Array[Island] = []
	var island = player.current_tile
	if !island:
		return
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
				var adjacent_island = get_island_by_row_col(adj_row, adj_col)
				if adjacent_island:
					adjacent_tiles.append(adjacent_island)
	
	return adjacent_tiles

func flood(island_pos: Vector2i, state: bool = true):
	var island = get_island_by_pos(island_pos)
	if !island:
		return
	if island.flooded and state:
		print("Island removed")
		if island.players_on.size() > 0:
			print("GAME OVER - a player drowned")
		# TODO: Check if paired totem islands have been removed without collecting their respective totem
		# TODO: Check if exfil tile has been removed
		# Delete the island
		islands.erase(island)
		island.queue_free()
	else:
		island.flooded = state
		if state:
			print("Flooding ", island)
			flood_discard.append(island_pos)
		else:
			print("Shoring up ", island)

func walk_here(player: Player, island: Island):
	if player.actions_left <= 0:
		print("Out of actions!")
		return
	
	var adjacent_tiles = get_adjacent_tiles_for_player(player)
	if !adjacent_tiles:
		print("No adjacent tiles!")
		return
		
	if !(island in adjacent_tiles):
		print("Can't walk here!")
		return
		
	if island == player.current_tile:
		print("Already here!")
		return
	
	player.current_tile.players_on.erase(player)
	player.current_tile = island
	player.current_tile.players_on.append(player)
	
	
	player.actions_left -= 1
	
func shore_up(player: Player, island: Island):
	if player.actions_left <= 0:
		print("Out of actions!")
		return
		
	var adjacent_tiles = get_adjacent_tiles_for_player(player)
	if !adjacent_tiles:
		print("No adjacent tiles!")
		return
		
	if !(island in adjacent_tiles):
		print("Can't shore up here!")
		return
		
	flood(island.pos, false)
	player.actions_left -= 1
	
