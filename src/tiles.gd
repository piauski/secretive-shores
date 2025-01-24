extends Node2D

enum Tile {
	NONE,
	GENERIC,
	EXFIL,
	SPAWN_DIVER,
	SPAWN_ENGINEER,
	SPAWN_NAVIGATOR,
	SPAWN_PILOT,
	SPAWN_EXPLORER,
	SPAWN_MESSENGER,
	AIR_WEAK,
	AIR_STRONG,
	FIRE_WEAK,
	FIRE_STRONG,
	WATER_WEAK,
	WATER_STRONG,
	EARTH_WEAK,
	EARTH_STRONG,
}

# Guaranteed to be present once.
const tile_types = [
	Tile.EXFIL,
	Tile.SPAWN_DIVER,
	Tile.SPAWN_ENGINEER,
	Tile.SPAWN_NAVIGATOR,
	Tile.SPAWN_PILOT,
	Tile.SPAWN_EXPLORER,
	Tile.SPAWN_MESSENGER,
	Tile.AIR_WEAK,
	Tile.AIR_STRONG,
	Tile.FIRE_WEAK,
	Tile.FIRE_STRONG,
	Tile.WATER_WEAK,
	Tile.WATER_STRONG,
	Tile.EARTH_WEAK,
	Tile.EARTH_STRONG,
]

const tile_data = {
	Tile.NONE: {
		names = ["NONE"],
		icon = ""
	},
	Tile.GENERIC: {
		names = ["Moonlit Cove", "Turtle Cove", "Palm Bay", "Sunset Beach", "Barrier Reef", "Cape Azure", "Great Dunes", "Winding River", "Cascading Falls", "Limestone Caves", "Metal Gates", "Old Pier", "Island Lighthouse", "Beacon Tower", "Ancient Ruins", "Abandoned Settlement", "Island Temple"],
		icon = ""
	},
	Tile.EXFIL: {
		names = ["Renegade's Retreat"],
		icon = "",
	},
	Tile.SPAWN_DIVER: {
		names = ["Hidden Grotto"],
		icon = "res://assets/player/diver.png",
	},
	Tile.SPAWN_ENGINEER: {
		names = ["Gadget Cache"],
		icon = "res://assets/player/engineer.png"
	},
	Tile.SPAWN_NAVIGATOR: {
		names = ["Chartered Beacon"],
		icon = "res://assets/player/navigator.png"
	},
	Tile.SPAWN_PILOT: {
		names = ["Rusty Hangar"],
		icon = "res://assets/player/pilot.png"
	},
	Tile.SPAWN_EXPLORER: {
		names = ["Mysterious Jungle"],
		icon = "res://assets/player/explorer.png"
	},
	Tile.SPAWN_MESSENGER: {
		names = ["Secure Channel"],
		icon = "res://assets/player/messenger.png"
	},
	Tile.AIR_WEAK: {
		names = ["Wild Windsong"],
		icon = "res://assets/totems/air.png"
	},
	Tile.AIR_STRONG: {
		names = ["Silent Windsong"],
		icon = "res://assets/totems/air.png"
	},
	Tile.FIRE_WEAK: {
		names = ["Fading Blaze"],
		icon = "res://assets/totems/fire.png"
	},
	Tile.FIRE_STRONG: {
		names = ["Burning Blaze"],
		icon = "res://assets/totems/fire.png"
	},
	Tile.WATER_WEAK: {
		names = ["Raging Tides"],
		icon = "res://assets/totems/water.png"
	},
	Tile.WATER_STRONG: {
		names = ["Still Tides"],
		icon = "res://assets/totems/water.png"
	},
	Tile.EARTH_WEAK: {
		names = ["Shifting Peaks"],
		icon = "res://assets/totems/earth.png"
	},
	Tile.EARTH_STRONG: {
		names = ["Stable Peaks"],
		icon = "res://assets/totems/earth.png"
	},
}
