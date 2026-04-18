class_name CharacterAbilityAimingStrategy extends RefCounted

func use_visible_mouse(_cursor_type: Cursor.Type = Cursor.Type.Pointer) -> void:
	pass

func use_captured_mouse() -> void:
	pass

func show_ground_target_marker() -> void:
	pass

func hide_ground_target_marker() -> void:
	pass

func set_ground_target_marker_position(_position: Vector3) -> void:
	pass

func show_enemy_target_marker() -> void:
	pass

func hide_enemy_target_marker() -> void:
	pass

func set_enemy_target_marker_position(_position: Vector2) -> void:
	pass

func raycast_from_mouse(_ray_range: float, _collision_mask: int = 0) -> Dictionary:
	return {}

func unproject_position(_position: Vector3) -> Vector2:
	return Vector2.ZERO
