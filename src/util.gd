extends Node

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
