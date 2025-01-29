class_name GameTurnEnd extends State

@export_category("Nodes")
@export var board: Board
@export var players: Players
@export var treasure_deck: TreasureDeck
@export var gui_layer: GuiLayer

@export_category("Timers")
@export var treasure_timer: Timer
@export var flood_timer: Timer

@export_category("Settings")
@export var DRAWN_TREASURE = 2

var player: Player

func flood():
	flood_timer.start()
	await flood_timer.timeout
	var amount = board.get_amount_of_flood_cards()
	if amount < 0:
		print("GAME OVER - the island sank")
	for i in range(amount):
		board.flood(board.get_flood_next())
		flood_timer.start()
		await flood_timer.timeout

func enter() -> void:
	player = players.current_player
	var flooded := false
	# Draw Treasure Cards
	treasure_timer.start()
	await treasure_timer.timeout
	for i in range(DRAWN_TREASURE):
		var card = treasure_deck.draw()
		if card == Util.TreasureType.WATER_RISING:
			print("WATER RISING")
			board.flood_level += 1
			board.reshuffle_flood_deck()
			await flood()
			flooded = true
		treasure_deck.discard(card)
		print(Util.TreasureType.keys()[card])
		treasure_timer.start()
		await treasure_timer.timeout
		
	# Draw Flood Cards
	if !flooded:
		await flood()
	
	transition("turn")
	

func exit() -> void:
	pass

func _on_flood_timer_timeout():
	pass
