extends Resource
class_name IslandResource


@export var name: String = ""
@export var type: Tiles.Tile = Tiles.Tile.NONE
@export var image: CompressedTexture2D = load("res://icon.svg")
@export var flooded: bool = false
@export var always_spawn: bool = false

@export var spawned_player: Classes.Class = Classes.Class.NONE
@export var spawned_totem: Totems.Totem = Totems.Totem.NONE
