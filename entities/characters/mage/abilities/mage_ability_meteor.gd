class_name MageAbilityMeteor extends MageAbilitySpell

var _aim_pos := Vector3.ZERO

var _is_started := false

func execute() -> void:
	_context.notify_casting_end()
	
	var node := _anim.scene.instantiate()
	node.position = _aim_pos
	_context.spawn_node(node)

func start() -> MageAbilityPhased.StartResult:
	_context.use_visible_mouse()
	_is_started = false
	
	return MageAbilityPhased.StartResult.Handled

func cancel() -> void:
	_context.use_captured_mouse()
	_context.hide_ground_target_marker()

func handle_input(event: InputEvent) -> HandleInputResult:
	if event.is_action(MageAbilityActions.ACTION_CANCEL) or (_is_started and event.is_action(MageAbilityActions.ACTION_METEOR)):
		return HandleInputResult.Cancel
	
	if event.is_action_released(MageAbilityActions.ACTION_METEOR):
		_is_started = true
	
	if event.is_action_pressed(MageAbilityActions.ACTION_ATTACK):
		_context.request_oneshot_animation(_anim.trigger)
		_context.use_captured_mouse()
		_context.hide_ground_target_marker()
		_context.notify_casting_started()
		
		return HandleInputResult.Trigger
	
	return HandleInputResult.Unhandled

func update(_delta: float) -> void:
	var cast_range := 20.0 # Todo: replace with configurable value
	var result := _context.raycast_from_mouse(cast_range, Layers.COLLISION_WORLD)
	
	if result:
		_context.show_ground_target_marker()
		_context.set_ground_target_marker_position(result.position)
		_aim_pos = result.position
	else:
		_context.hide_ground_target_marker()
