extends Camera2D

var dragging = false
var last_mouse_pos = Vector2()
var sensitivity = 1.0

var zoom_speed = 0.1
var min_zoom = Vector2(0.5,0.5)
var max_zoom = Vector2(2.0,2.0)

func _ready():
	zoom = Vector2(0.5,0.5)
	global_position = Vector2(500,500)
func _process(delta):
	if Input.is_action_just_pressed("mouse_right"):
		dragging = true
		last_mouse_pos = get_global_mouse_position()
	
	elif Input.is_action_just_released("mouse_right"):
		dragging = false

	if dragging:
		var mouse_pos = get_global_mouse_position()
		var mdelta = mouse_pos - last_mouse_pos
		global_position -= mdelta * sensitivity * zoom.length()
		last_mouse_pos = mouse_pos
	
	if Input.is_action_just_released("mouse_scroll_up"):
		zoom += Vector2(zoom_speed, zoom_speed)
	elif Input.is_action_just_released("mouse_scroll_down"):
		zoom -= Vector2(zoom_speed, zoom_speed)

	zoom = zoom.clamp(min_zoom, max_zoom)
		
