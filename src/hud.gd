extends CanvasLayer

@onready var turn_indicator_player_image = $HUD/TurnIndicator/PlayerImage
@onready var turn_indicator_player_label = $HUD/TurnIndicator/PlayerLabel

@export var board: Board
@export var players: Players

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_player = players.current_player
	if current_player:
		turn_indicator_player_image.texture = current_player.sprite.texture
		turn_indicator_player_label.text = "%s's Turn" % current_player.name
