class_name Player extends Node2D

# Onready Variables
@onready var sprite: Sprite2D = $Sprite

# Export Variables
@export var resource: PlayerResource = preload("res://resources/player/diver.tres"):
	set(value):
		resource = value
		load_resource(resource)

@export var current_tile: Island:
	get:
		return current_tile
	set(value):
		current_tile = value
		position = current_tile.position + (Vector2(randf() - 0.5, randf() - 0.5) * 50)
		

@export var clazz: Classes.Class = Classes.Class.NONE
@export var special_action: Classes.SpecialAction = Classes.SpecialAction.NONE
@export var tile_pos: Vector2

# Local Variables
var current_player = false
var actions_left: int = 0

func load_resource(_resource: PlayerResource):
	set_name(_resource.name)
	clazz = _resource.clazz
	special_action = _resource.special_action
	sprite.texture = _resource.image
	

func turn(state: bool) -> void:
	if state:
		scale = Vector2(2,2)
		actions_left = 3
	else:
		scale = Vector2(1,1)
		actions_left = 0
