class_name AbilityAimingLocationHandler extends AbilityAimingHandler

var _data: AbilityTargetingLocation
var _aim_pos := Vector3.ZERO

func setup(data: AbilityTargeting) -> void:
	_data = data
	_context.use_visible_mouse(Cursor.Type.Pointer)

func handle_input(event: InputEvent) -> bool:
	if event.is_action_pressed("ui_cancel"):
		_emit_cancel()
		return true
	
	if event.is_action_pressed(_data.input_trigger):
		_cleanup_ui_state()
		_emit_target_aquired(AbilityAimingResultLocation.new(_aim_pos))
		return true
	
	return false

func tick(_delta: float) -> void:
	var result := _context.raycast_from_mouse(_data.cast_range, Layers.COLLISION_WORLD)
	
	if result:
		_context.show_ground_target_marker()
		_context.set_ground_target_marker_position(result.position)
		_aim_pos = result.position
	else:
		_context.hide_ground_target_marker()

func cancel() -> void:
	_cleanup_ui_state()

func _cleanup_ui_state() -> void:
	_context.use_captured_mouse()
	_context.hide_ground_target_marker()
