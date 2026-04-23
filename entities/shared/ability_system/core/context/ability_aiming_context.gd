class_name AbilityAimingContext extends RefCounted

var _strategy: AbilityAimingStrategy

func _init(strategy: AbilityAimingStrategy) -> void:
	_strategy = strategy

func use_visible_mouse(cursor_type: Cursor.Type = Cursor.Type.Pointer) -> void:
	_strategy.use_visible_mouse(cursor_type)

func use_captured_mouse() -> void:
	_strategy.use_captured_mouse()

func show_ground_target_marker() -> void:
	_strategy.show_ground_target_marker()

func hide_ground_target_marker() -> void:
	_strategy.hide_ground_target_marker()

func set_ground_target_marker_position(position: Vector3) -> void:
	_strategy.set_ground_target_marker_position(position)

func show_enemy_target_marker() -> void:
	_strategy.show_enemy_target_marker()

func hide_enemy_target_marker() -> void:
	_strategy.hide_enemy_target_marker()

func set_enemy_target_marker_position(position: Vector2) -> void:
	_strategy.set_enemy_target_marker_position(position)

func raycast_from_mouse(ray_range: float, collision_mask: int = 0) -> Dictionary:
	return _strategy.raycast_from_mouse(ray_range, collision_mask)

func unproject_position(position: Vector3) -> Vector2:
	return _strategy.unproject_position(position)

func get_ai_target_handler() -> AiTargetHandler:
	return _strategy.get_ai_target_handler()

func show_directional_marker() -> void:
	_strategy.show_directional_marker()

func hide_directional_marker() -> void:
	_strategy.hide_directional_marker()

func set_aim_yaw(angle: float) -> void:
	_strategy.set_aim_yaw(angle)

func set_aim_pitch(angle: float) -> void:
	_strategy.set_aim_pitch(angle)

func get_origin_position() -> Vector3:
	return _strategy.get_origin_position()
