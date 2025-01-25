extends Node2D
class_name Island

@onready var background_image = $BackgroundImage
@onready var island_image = $IslandImage
@onready var player_icon = $PlayerIcon
@onready var totem_icon = $TotemIcon
@onready var name_label = $NameLabel
@onready var area_2d = $Area2D

var type: Tiles.Tile = Tiles.Tile.NONE
var flooded: bool = false
var always_spawn: bool = false
var spawned_player: Classes.Class = Classes.Class.NONE
var spawned_totem: Totems.Totem = Totems.Totem.NONE

var row: int = 0
var col: int = 0

@export var resource: IslandResource:
	set(value):
		resource = value
		load_resource(resource)
		


func load_resource(resource: IslandResource):
	set_name(resource.name)
	name_label.text = resource.name
	type = resource.type
	island_image.texture = resource.image
	flooded = resource.flooded
	always_spawn = resource.always_spawn
	spawned_player = resource.spawned_player
	spawned_totem = resource.spawned_totem

	# Player Icon
	if resource.spawned_player != Classes.Class.NONE:
		player_icon.visible = true
		player_icon.texture = load("res://resources/player/%s.tres" % Classes.Class.keys()[resource.spawned_player].to_lower()).image
	else:
		player_icon.visible = false
		
	# Totem Icon
	if resource.spawned_totem != Totems.Totem.NONE:
		totem_icon.visible = true
		totem_icon.texture = load("res://resources/totem/%s.tres" % Totems.Totem.keys()[resource.spawned_totem].to_lower()).image
	else:
		totem_icon.visible = false
	
