extends Node2D

enum Class {
	NONE,
	DIVER,
	ENGINEER,
	NAVIGATOR,
	PILOT,
	EXPLORER,
	MESSENGER,
}

var class_data = {
	Class.DIVER: {
		description = "Move through 1 or more adjacent flooded and/or missing tiles for 1 action. (Must end your turn on a tile.)",
		sprite = "res://assets/player/diver.png",
		name = "Diver",
	},
	Class.ENGINEER: {
		description = "Shore up 2 tiles for 1 action.",
		sprite = "res://assets/player/engineer.png",
		name = "Engineer",
	},
	Class.NAVIGATOR: {
		description = "Move another player up to 2 adjacent tiles for 1 action.",
		sprite = "res://assets/player/navigator.png",
		name = "Navigator"
	},
	Class.PILOT: {
		description = "Once per turn, fly to any tile on the island for 1 action.",
		sprite = "res://assets/player/pilot.png",
		name = "Pilot",
	},
	Class.EXPLORER: {
		description = "Move and/or shore up diagonally.",
		sprite = "res://assets/player/explorer.png",
		name = "Explorer",
	},
	Class.MESSENGER: {
		description = "Give Treasure cards to a player anywhere on the island for 1 action per card.",
		sprite = "res://assets/player/messenger.png",
		name = "Messenger",
	},
}
