extends Node2D
class_name Island

@export var island_type: Tiles.Tile
@export var island_name: String

@onready var Art:Sprite2D = $Art
@onready var Name:Label = $Name
@onready var PlayerIcon:Sprite2D = $PlayerIcon
@onready var TotemIcon:Sprite2D = $TotemIcon
@onready var Background:Sprite2D = $Background

@onready var original_bg_scale = Background.scale

@onready var art_material = Art.material.duplicate()

@export var flooded: bool = false:
	get:
		return flooded
	set(value):
		if value and flooded:
			remove_self()
		flooded = value
		_update_flood_visuals()
		
func _update_flood_visuals():
	if flooded:
		Background.texture = load("res://assets/island/tile_bg_flooded.png")
		art_material.set_shader_parameter("desaturate_amount", 1)
	else:
		Background.texture = load("res://assets/island/tile_bg.png")
		art_material.set_shader_parameter("desaturate_amount", 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Name.text = island_name
	Art.material = art_material
	var icon = Tiles.tile_data[island_type].icon
	if icon.begins_with("res://assets/player/"):
		PlayerIcon.visible = true
		TotemIcon.visible = false
		PlayerIcon.texture = load(icon)
	elif icon.begins_with("res://assets/totems/"):
		TotemIcon.visible = true
		PlayerIcon.visible = false
		TotemIcon.texture = load(icon)
	else:
		TotemIcon.visible = false
		PlayerIcon.visible = false
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

# Called when the island has flooded twice.
# TODO: game over if any players are here.
func remove_self():
	print("DIE")
	queue_free()


func _on_button_pressed() -> void:
	print("PRESSED ", name)


func _on_button_mouse_entered() -> void:
	Background.scale = original_bg_scale * 1.2


func _on_button_mouse_exited() -> void:
	Background.scale = original_bg_scale 
