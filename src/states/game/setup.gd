extends State
class_name GameSetup

@export var board: Board
@export var players: Players

func enter() -> void:
	board.generate_island()
	players.spawn_players(board)
	
	# Flood 6 random tiles
	var children = board.get_islands()
	children.shuffle()
	for i in range(6):
		children[i].flooded = true
		
	transition("turn")
