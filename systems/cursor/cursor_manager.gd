extends Node

var cursor_attack := preload("res://assets/textures/kenney/cursor/tool_sword_b.png")
var cursor_pointer := preload("res://assets/textures/kenney/cursor/pointer_scifi_b.png")

var _last_mouse_pos: Vector2

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_pointer)
	# Initialize to screen center
	_last_mouse_pos = get_viewport().get_visible_rect().size / 2

func set_visible_mode(type: Cursor.Type = Cursor.Type.Pointer) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.warp_mouse(_last_mouse_pos)
	
	match type:
		Cursor.Type.Attack: use_attack_cursor()
		Cursor.Type.Pointer: use_pointer()

func set_captured_mode() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		_last_mouse_pos = get_viewport().get_mouse_position()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func use_attack_cursor() -> void:
	Input.set_custom_mouse_cursor(cursor_attack, Input.CURSOR_ARROW)
	
func use_pointer() -> void:
	Input.set_custom_mouse_cursor(cursor_pointer, Input.CURSOR_ARROW)
