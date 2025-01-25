extends State
class_name GameTurn

@export var board: Board
@export var players: Players

signal player_turn(Player)

func enter() -> void:
	var player = players.get_next()
	print(player, "'s Turn!")
	
	transition("turn_wait")
		
