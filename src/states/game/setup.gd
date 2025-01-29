extends State
class_name GameSetup

@export var board: Board
@export var players: Players
@export var gui_layer: GuiLayer

func enter() -> void:
	board.generate_island()
	board.generate_flood_deck()
	print("flood deck", board.flood_deck)
	players.spawn_players(board)
	gui_layer.populate_player_list()
	
	# Flood 6 random tiles
	for i in range(6):
		board.flood(board.get_flood_next())
		
	transition("turn")
