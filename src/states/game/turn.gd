extends State
class_name GameTurn

@export var board: Board
@export var players: Players

func enter() -> void:
	var player = players.get_next()
	print(player, "'s Turn!")
	print("Transition")
	
	transition("turn_wait")
		
