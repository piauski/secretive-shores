extends Node2D
class_name Island

@onready var background_image = $BackgroundImage
@onready var island_image = $IslandImage
@onready var island_image_material = island_image.material.duplicate()
@onready var player_icon = $PlayerIcon
@onready var totem_icon = $TotemIcon
@onready var name_label = $NameLabel
@onready var area_2d = $Area2D

@export var resource: IslandResource:
	set(value):
		resource = value
		load_resource(resource)

var type: Tiles.Tile = Tiles.Tile.NONE
var players_on: Array[Player] = []

var flooded: bool = false:
	set(value):
		flooded = value
		update_flood_visuals()
var always_spawn: bool = false

var spawned_player: Classes.Class = Classes.Class.NONE
var spawned_totem: Totems.Totem = Totems.Totem.NONE

var row: int = 0
var col: int = 0

var pos: Vector2i:
	get:
		return Vector2i(row, col)

func load_resource(_resource: IslandResource):
	set_name(_resource.name)
	name_label.text = _resource.name
	type = _resource.type
	island_image.texture = _resource.image
	flooded = _resource.flooded
	always_spawn = _resource.always_spawn
	spawned_player = _resource.spawned_player
	spawned_totem = _resource.spawned_totem

	# Flood visuals
	update_flood_visuals()
		
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
	
func update_flood_visuals():
	if flooded:
		background_image.texture = preload("res://assets/island/tile_bg_flooded.png")
		island_image_material.set_shader_parameter("desaturate_amount", 1)
	else:
		background_image.texture = preload("res://assets/island/tile_bg.png")
		island_image_material.set_shader_parameter("desaturate_amount", 0)
