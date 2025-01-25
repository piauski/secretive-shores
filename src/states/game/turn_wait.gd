extends State
class_name GameTurnWait

@export var board: Board
@export var players: Players

var input_received = false


func enter() -> void:
	print("Entered waiting state ", players.current_player)
	print(board.get_adjacent_tiles_for_player(players.current_player))
	

func update(delta:float) -> void:
	if input_received:
		transition("turn")
