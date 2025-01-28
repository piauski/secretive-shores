extends State
class_name GameSetup

@export var board: Board
@export var players: Players

func enter() -> void:
	board.generate_island()
	board.generate_flood_deck()
	print(board.flood_deck)
	players.spawn_players(board)
	
	# Flood 6 random tiles
	for i in range(6):
		board.flood(board.get_flood_next(), true)
		
	transition("turn")
