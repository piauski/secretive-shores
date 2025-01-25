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

@export var resource: IslandResource:
	set(value):
		resource = value
		


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_resource()
	

func load_resource():
	set_name(resource.name)
	name_label.text = name
	type = resource.type
	island_image.texture = resource.image
	flooded = resource.flooded
	always_spawn = resource.always_spawn

	# Player Icon
	if resource.spawned_player != Classes.Class.NONE:
		player_icon.visible = true
		player_icon.texture = load("res://assets/player/%s.png" % Classes.Class.keys()[resource.spawned_player].to_lower())
	else:
		player_icon.visible = false
		
	# Totem Icon
	if resource.spawned_totem != Totems.Totem.NONE:
		totem_icon.visible = true
		totem_icon.texture = load("res://assets/totem/%s.png" % Totems.Totem.keys()[resource.spawned_totem].to_lower())
	else:
		totem_icon.visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
