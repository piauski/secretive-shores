extends State
class_name GameTurn

@export var board: Board
@export var players: Players


func enter() -> void:
	var player = players.get_next() as Player
	player.turn(true)
	print(player, "'s Turn!")
	
	transition("turn_wait")
		
