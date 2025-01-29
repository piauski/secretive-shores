class_name GameTurnWait extends State

@export var board: Board
@export var players: Players
@export var gui_layer: GuiLayer

var input_received = false
var player: Player

func enter() -> void:
	# Connect signals
	board.island_clicked.connect(_on_island_clicked)
	board.clicked.connect(_on_clicked)
	
	# Set up temporary variables
	player = players.current_player


func exit() -> void:
	# Disconnect temporary signals
	player.turn(false)

	# Disconnect signals
	board.island_clicked.disconnect(_on_island_clicked)
	board.clicked.disconnect(_on_clicked)

func _on_island_clicked(island: Island, position: Vector2):
	gui_layer.spawn_action_menu(island, position)
	
func _on_clicked(position: Vector2):
	gui_layer._on_clicked(position)

func update(_delta: float) -> void:
	if player.actions_left <= 0:
		transition("turn_end")
