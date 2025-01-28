extends State
class_name GameTurnWait

@export var board: Board
@export var players: Players

var input_received = false
var player: Player

func enter() -> void:
	player = players.current_player
	player.action.connect(_on_action)
	print("Entered waiting state ", player)
	print(board.get_adjacent_tiles_for_player(player))

func exit() -> void:
	player.action.disconnect(_on_action)

func _on_action(action):
	pass

func update(delta:float) -> void:
	if input_received:
		transition("turn")
