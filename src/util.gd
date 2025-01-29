extends Node

enum ActionType {
	NONE,
	WALK_HERE,
	SHORE_UP,
	EXAMINE,
	CANCEL,
}

enum TreasureType {
	NONE,
	SANDBAGS,
	HELICOPTER,
	WATER_RISING,
	TOTEM_AIR,
	TOTEM_WATER,
	TOTEM_EARTH,
	TOTEM_FIRE
}

var strip_bbcode_regex = RegEx.new()

func strip_bbcode(text: String) -> String:
	strip_bbcode_regex.compile("\\[.*?\\]")
	return strip_bbcode_regex.sub(text, "", true)
	
func get_longest_string(strings: Array[String]) -> String:
	var max_len = -INF
	var max_string
	
	for string in strings:
		var stripped = strip_bbcode(string)
		if stripped.length() > max_len:
			max_len = stripped.length()
			max_string = stripped
	return max_string
	

func load_all_resources_in_dir(path) -> Array[Resource]:
	var dir_access = DirAccess.open(path)
	var resources: Array[Resource]
	if dir_access:
		var files = dir_access.get_files()
		for file in files:
			if file.ends_with(".tres"):
				var file_path = path + file
				var resource = load(file_path)
				if resource:
					resources.append(resource)
				else:
					printerr("Failed to load resource:", file)
	else:
		printerr("Failed to open directory")
	return resources

func get_extents(nodes: Array):
	var min_x = INF
	var min_y = INF
	var max_x = -INF
	var max_y = -INF
	for node in nodes:
		var transform = node.get_global_transform()
		var rect = Rect2(transform.get_origin(), transform.get_scale())
		min_x = min(min_x, rect.position.x)
		min_y = min(min_y, rect.position.y)
		max_x = max(max_x, rect.position.x + rect.size.x)
		max_y = max(max_y, rect.position.y + rect.size.y)
	return Rect2(min_x, min_y, max_x - min_x, max_y - min_y)
	
func world_to_screen_position(camera: Camera2D, position: Vector2) -> Vector2:
	return (position - camera.global_position) * camera.zoom + Vector2(get_viewport().size / 2)
