extends State
class_name GameTurn

@export var board: Board
@export var players: Players

var current_player: Player

signal player_turn(Player)

func enter() -> void:
	current_player = players.get_next()
	print(current_player, "'s Turn!")
	
	transition("turn_wait")
		
