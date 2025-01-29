class_name PlayerListEntry extends Control

@export var player_image: TextureRect
@export var player_label: RichTextLabel
@export var background: NinePatchRect

@export var resource: PlayerResource = preload("res://resources/player/diver.tres"):
	set(value):
		resource = value
		load_resource(resource)

var clazz: Classes.Class = Classes.Class.NONE

@export var background_texture: CompressedTexture2D
@export var background_texture_highlight: CompressedTexture2D

func load_resource(_resource: PlayerResource):
	set_name(_resource.name)
	player_label.text = name
	clazz = _resource.clazz
	player_image.texture = _resource.image

func highlight(state: bool):
	if state:
		background.texture = background_texture_highlight
	else:
		background.texture = background_texture
