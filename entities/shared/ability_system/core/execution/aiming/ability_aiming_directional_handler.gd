class_name AbilityAimingDirectionalHandler extends AbilityAimingHandler

var _data: AbilityTargetingDirectional
var _yaw: float = 0.0
var _pitch: float = 0.0

func setup(data: AbilityTargeting) -> void:
	_data = data as AbilityTargetingDirectional
	_context.show_directional_marker()
	_context.use_visible_mouse()

func tick(_delta: float) -> void:
	var ray_result := _context.raycast_from_mouse(1000.0, Layers.COLLISION_WORLD)
	
	if ray_result.is_empty():
		return
	
	var target_pos: Vector3 = ray_result.position
	var player_pos: Vector3 = _context.get_origin_position()
	
	var diff := target_pos - player_pos
	
	_yaw = atan2(-diff.x, -diff.z)
	
	var horizontal_dist := Vector2(diff.x, diff.z).length()
	_pitch = atan2(diff.y, horizontal_dist)
	
	_context.set_aim_yaw(_yaw)
	_context.set_aim_pitch(_pitch)

func handle_input(event: InputEvent) -> AbilityHandleInputResult:
	if event.is_action_pressed("ui_cancel"):
		_cleanup_ui_state()
		_emit_cancel()
		return AbilityHandleInputResult.handled(&"ui_cancel")
		
	if event.is_action_pressed(_data.input_trigger):
		_cleanup_ui_state()
		_emit_target_aquired(AbilityAimingResultDirectional.new(_yaw, _pitch))
		return AbilityHandleInputResult.handled(_data.input_trigger)
	
	return AbilityHandleInputResult.unhandled()

func cancel() -> void:
	_cleanup_ui_state()

func _cleanup_ui_state() -> void:
	_context.hide_directional_marker()
	_context.use_captured_mouse()
