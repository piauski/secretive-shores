extends Node2D
class_name Player

@onready var sprite: Sprite2D = $Sprite

@export var current_tile: Island:
	get:
		return current_tile
	set(value):
		current_tile = value
		position = current_tile.position + (Vector2(randf() - 0.5, randf() - 0.5) * 50)

var semaphore = Semaphore.new()
var input_received = false
var current_player = false

@export var clazz: Classes.Class:
	get:
		return clazz
	set(value):
		clazz = value
		set_texture_from_class()

@export var tile_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_texture_from_class()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_texture_from_class():
	sprite.set_texture(load(Classes.class_data[clazz].sprite))
	
	
func get_adjacent_tiles() -> Array[Island]:
	return [current_tile]
	
