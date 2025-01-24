extends State
class_name GameTurnWait

@export var board: Board
@export var players: Players

var input_received = false


func enter() -> void:
	print("Entered waiting state", players.current_player)
	print(players.current_player.get_adjacent_tiles())
	
func update(delta:float) -> void:
	if input_received:
		transition("turn")
