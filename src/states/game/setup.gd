extends State
class_name GameSetup

@export var board: Board
@export var players: Players

func enter() -> void:
	board.generate_island()
	players.spawn_players(board)
	
	# Flood 6 random tiles
	var islands = board.get_islands()
	islands.shuffle()
	for i in range(6):
		board.flood(islands[i], true)
		
	transition("turn")
