class_name CharacterAbilityGroundTarget extends CharacterPhasedAbility

var _context: PhasedContext
var _data: GroundTargetAbility

var _aim_pos := Vector3.ZERO
var _is_started := false

func _init(context: PhasedContext, data: GroundTargetAbility) -> void:
	_context = context
	_data = data

static func create(context: PhasedContext, data: GroundTargetAbility) -> CharacterAbilityGroundTarget:
	context.update_cast_point(data)
	return CharacterAbilityGroundTarget.new(context, data)

func has_resources() -> bool:
	return _context.has_resources(_data.cost)

func use_resources() -> void:
	_context.use_resources(_data.cost)

func execute() -> ExecuteResult:
	_context.notify_casting_end()
	
	var node := _data.scene.instantiate()
	_context.spawn_node(node)
	node.global_position = _aim_pos
	
	return ExecuteResult.Trigger

func start() -> CharacterPhasedAbility.StartResult:
	_context.use_visible_mouse()
	_is_started = false
	
	return CharacterPhasedAbility.StartResult.HandleWithInput

func update(_delta: float) -> void:
	var result := _context.raycast_from_mouse(_data.cast_range, Layers.COLLISION_WORLD)
	
	if result:
		_context.show_ground_target_marker()
		_context.set_ground_target_marker_position(result.position)
		_aim_pos = result.position
	else:
		_context.hide_ground_target_marker()

func handle_input(event: InputEvent) -> HandleInputResult:
	if event.is_action(MageAbilityActions.ACTION_CANCEL) or (_is_started and event.is_action(MageAbilityActions.ACTION_METEOR)):
		return HandleInputResult.Cancel
	
	if event.is_action_released(MageAbilityActions.ACTION_METEOR):
		_is_started = true
	
	if event.is_action_pressed(MageAbilityActions.ACTION_ATTACK):
		_context.animate(_data.anim)
		_context.use_captured_mouse()
		_context.hide_ground_target_marker()
		_context.notify_casting_started()
		
		return HandleInputResult.Trigger
	
	return HandleInputResult.Unhandled

func cancel() -> void:
	_context.use_captured_mouse()
	_context.hide_ground_target_marker()

func tick_cast(_delta: float) -> void:
	_context.notify_casting_progressed(
		_context.get_animation_position(_data.anim),
		_data.anim.cast_point,
	)
