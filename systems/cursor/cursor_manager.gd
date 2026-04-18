extends Node

var cursor_attack := preload("res://assets/textures/kenney/cursor/tool_sword_b.png")
var cursor_pointer := preload("res://assets/textures/kenney/cursor/pointer_scifi_b.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_pointer)

func use_attack_cursor() -> void:
	Input.set_custom_mouse_cursor(cursor_attack, Input.CURSOR_ARROW)
	
func use_pointer() -> void:
	Input.set_custom_mouse_cursor(cursor_pointer, Input.CURSOR_ARROW)
