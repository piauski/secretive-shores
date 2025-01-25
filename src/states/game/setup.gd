extends State
class_name GameSetup

@export var board: Board
@export var players: Players

func enter() -> void:
	board.generate_island()
	
func enter_() -> void:
	board.generate_island()
	var classes = Classes.Class.duplicate().values()
	classes.shuffle()
	var player_classes: Array
	for i in range(players.PLAYER_COUNT):
		player_classes.append(classes.pop_front())
	
	players.spawn(player_classes, board)
	
	
	# Flood 6 random tiles
	var children = board.get_islands()
	children.shuffle()
	for i in range(6):
		children[i].flooded = true
	
	#transition("turn")
