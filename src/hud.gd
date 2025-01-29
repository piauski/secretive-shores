class_name GuiLayer extends CanvasLayer

@export_category("Nodes")
@export var camera: Camera2D
@export var board: Board
@export var players: Players
@export var hud: Control

@export_category("Player List")
@export var player_list: VBoxContainer
@export var player_list_entry_scene: PackedScene

@export_category("Actions")
@export var actions_remaining: RichTextLabel
@export var action_menu_scene: PackedScene
@export var action_menu_entry_scene: PackedScene

var current_player: Player
var current_player_list_entry: PlayerListEntry

var action_menu: Control
var should_delete_action_menu: bool

func get_player_list_entries() -> Array[Node]:
	return player_list.get_children().filter(func(child): return child is PlayerListEntry)
	
func get_player_list_entry_by_class(clazz: Classes.Class) -> Node:
	return player_list.get_children().filter(func(child): return child is PlayerListEntry and child.clazz == clazz)[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if players.current_player != current_player:
		current_player = players.current_player as Player
	if current_player:
		current_player_list_entry = get_player_list_entry_by_class(current_player.clazz)
		for entry in get_player_list_entries():
			entry.highlight(false)
		current_player_list_entry.highlight(true)
		actions_remaining.text = "     Actions Remaining: %d" % current_player.actions_left
	
	if should_delete_action_menu:
		should_delete_action_menu = false
		action_menu.queue_free()
		action_menu = null
		
func populate_player_list():
	for player in players.get_players():
		var new_player_entry = player_list_entry_scene.instantiate()
		new_player_entry.resource = player.resource
		player_list.add_child(new_player_entry)
		

func _on_action_menu_mouse_exited():
	action_menu.mouse_exited.disconnect(_on_action_menu_mouse_exited)
	should_delete_action_menu = true

func _on_clicked(_position: Vector2):
	if action_menu and !get_viewport().gui_get_hovered_control():
		should_delete_action_menu = true

func _on_action_entry_pressed(action: ActionMenuEntry):
	var action_type: Util.ActionType = action.action_type
	match action_type:
		Util.ActionType.WALK_HERE:
			board.walk_here(current_player, action.island)
			should_delete_action_menu = true
		Util.ActionType.SHORE_UP:
			board.shore_up(current_player, action.island)
			should_delete_action_menu = true
		Util.ActionType.EXAMINE:
			board.examine(action.island)
			should_delete_action_menu = true
		Util.ActionType.CANCEL:
			should_delete_action_menu = true
		_:
			printerr("ERROR: Unhandled case in _on_action_entry_pressed: ", action_type)

func spawn_action_menu(island: Island, position: Vector2):
	if action_menu:
		return
	action_menu = action_menu_scene.instantiate()
	action_menu.global_position = Util.world_to_screen_position(camera, position)

	var action_menu_list := action_menu.get_node("VBoxContainer") as VBoxContainer
	var label_strings: Array[String] = []
	
	for action_name in Util.ActionType.keys():
		var action: Util.ActionType = Util.ActionType[action_name]
		if action == Util.ActionType.NONE:
			continue
		
		var new_action = action_menu_entry_scene.instantiate() as ActionMenuEntry
		new_action.action_type = action
		new_action.island = island
		new_action.name = action_name
		
		var label = new_action.get_node("RichTextLabel") as RichTextLabel
		var label_text = action_name.capitalize()
		if action == Util.ActionType.WALK_HERE or action == Util.ActionType.SHORE_UP:
			label_text += " [color=#ffff00]%s[/color]" % island.name
		label.text = label_text
		label_strings.append(label_text)
	
		new_action.pressed.connect(func():
			should_delete_action_menu = false
			_on_action_entry_pressed(new_action))
		
		action_menu_list.add_child(new_action)
		
	action_menu.custom_minimum_size.y = action_menu_list.get_minimum_size().y + 10
	action_menu.custom_minimum_size.x = hud.get_theme_default_font().get_string_size(
		Util.get_longest_string(label_strings),
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		hud.get_theme_default_font_size()).x + 20
	
	# action_menu.mouse_exited.connect(_on_action_menu_mouse_exited)
	hud.call_deferred("add_child", action_menu)
	
