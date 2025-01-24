extends Node2D
class_name Players

@export var PLAYER_COUNT = 4
@export var player_scene: PackedScene = preload("res://player.tscn")

var current_player: Player

var players: Array = []

func spawn(classes, board):
	for clazz in classes:
		var player_instance = player_scene.instantiate()
		add_child(player_instance)
		player_instance.clazz = clazz
		player_instance.set_name(Classes.class_data[clazz].name)
		player_instance.current_tile = board.get_spawn_tile_for_class(clazz)
		player_instance.position = player_instance.current_tile.position + (Vector2(randf() - 0.5, randf() - 0.5) * 50)
		
		players.push_back(player_instance)

func get_players():
	return players

# Returns first player and pushes them back to the end - i.e. cycles as a turn
func get_next():
	var player = players.pop_front()
	for plr in players:
		plr.current_player = false
	player.current_player = true
	current_player = player
	players.push_back(player)
	return player
