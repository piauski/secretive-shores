extends CanvasLayer

@export_category("Nodes")
@export var turn_indicator_player_image: TextureRect
@export var turn_indicator_player_label: RichTextLabel

@export var player_list: VBoxContainer
@export var player_list_entry_scene: PackedScene

@export var board: Board
@export var players: Players

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_player = players.current_player
	if current_player:
		turn_indicator_player_image.texture = current_player.sprite.texture
		turn_indicator_player_label.text = "%s's Turn" % current_player.name
		
func populate_player_list():
	for player in players.get_players():
		var new_player = player_list_entry_scene.instantiate()
		
