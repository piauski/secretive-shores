extends Node2D
class_name Player

@onready var sprite: Sprite2D = $Sprite

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

var current_player = false

func load_resource(resource: PlayerResource):
	set_name(resource.name)
	clazz = resource.clazz
	special_action = resource.special_action
	sprite.texture = resource.image
