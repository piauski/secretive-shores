extends Node2D
class_name Players

@export var PLAYER_COUNT = 4
@export var player_scene: PackedScene = preload("res://scenes/player.tscn")
@export var player_resources_path: String = "res://resources/player/"

var current_player: Player

var players: Array = []

func spawn_players(board: Board):
	var player_resources = Util.load_all_resources_in_dir(player_resources_path) as Array[PlayerResource]
	player_resources.shuffle()
	player_resources.resize(PLAYER_COUNT)
	for resource in player_resources:
		var new_player = player_scene.instantiate() as Player
		add_child(new_player)
		players.append(new_player)
		new_player.resource = resource
		# This assumes only one spawn tile per class.
		# FIXME: If multiple spawn tiles are allowed, change this.
		new_player.current_tile = board.get_spawn_tiles_for_class(new_player.clazz)[0]

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
