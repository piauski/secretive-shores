extends Node2D

@onready var board = $Board
@onready var players = $Players


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await board.generate_island()
	var classes = Classes.Class.duplicate().values()
	classes.shuffle()
	var player_classes: Array
	for i in range(players.PLAYER_COUNT):
		player_classes.append(classes.pop_front())
	
	players.spawn(player_classes, board)
	
	
	# Flood 6 random tiles
	var children = board.get_children()
	children.shuffle()
	for i in range(6):
		children[i].flooded = true
	
	print(players.get_players())
	
	var player = players.get_next()
	while player:
		print(player, "'s Turn!")
		await player.turn()
		player = players.get_next()
