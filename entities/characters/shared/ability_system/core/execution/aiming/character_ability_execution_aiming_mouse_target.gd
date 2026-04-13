class_name CharacterAbilityExecutionAimingMouseTarget extends CharacterAbilityExecutionAimingHandler

var _data: CharacterAbilityTargetingMouseTarget

var _target: Node3D

func setup(data: CharacterAbilityTargeting) -> void:
	_data = data
	_context.use_visible_mouse(Cursor.Type.Attack)

func handle_input(event: InputEvent) -> bool:
	if event.is_action_pressed("ui_cancel"):
		_emit_cancel()
		return true
	
	if event.is_action_pressed(_data.input_trigger):
		_cleanup_ui_state()
		_emit_target_aquired(CharacterAbilityAimingResultMouseTarget.new(_target))
		return true
	
	return false

func tick(_delta: float) -> void:
	var result := _context.raycast_from_mouse(_data.cast_range, Layers.COLLISION_ENEMY_COLLISION)
	
	if result:
		var aim_target = result.collider.get_target_point() if result.collider.has_method("get_target_point") else result.collider
		
		var enemy_position = aim_target.global_position
		var enemy_position_2d := _context.unproject_position(enemy_position)
		
		_context.set_enemy_target_marker_position(enemy_position_2d)
		_context.show_enemy_target_marker()
		_target = result.collider
	else:
		_context.hide_enemy_target_marker()
		_target = null

func cancel() -> void:
	_cleanup_ui_state()

func _cleanup_ui_state() -> void:
	_context.use_captured_mouse()
	_context.hide_enemy_target_marker()
