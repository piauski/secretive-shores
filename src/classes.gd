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

enum SpecialAction {
	NONE,
	MOVE_THRU_ADJ_MISSING_TILES,
	SHORE_UP_TWICE,
	MOVE_ANOTHER_PLAYER_TWICE,
	FLY_ANY_TILE,
	MOVE_SHORE_UP_DIAG,
	GIVE_CARDS_REMOTELY
}
