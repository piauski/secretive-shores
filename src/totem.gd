extends Node2D
class_name Totem

@onready var type: Totems.Totem = Totems.Totem.NONE
@onready var image: Sprite2D = $TotemImage

@export var resource: TotemResource:
	set(value):
		resource = value
		load_resource(resource)
		


func load_resource(_resource: TotemResource):
	set_name(_resource.name)
	type = _resource.type
	image.texture = _resource.image
	
