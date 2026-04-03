class_name CharacterGroundTargetAbility extends CharacterPhasedAbility

var _new_data: CharacterAbilityGroundTarget

var _aim_pos := Vector3.ZERO
var _is_started := false

func _init(context: PhasedContext, new_data: CharacterAbilityGroundTarget) -> void:
	super(new_data, context)
	_new_data = new_data

static func create(context: PhasedContext, new_data: CharacterAbilityGroundTarget) -> CharacterGroundTargetAbility:
	context.update_cast_point(new_data)
	return CharacterGroundTargetAbility.new(context, new_data)

func execute() -> ExecuteResult:
	_context.notify_casting_end()
	
	var node := _new_data.scene.instantiate()
	_context.spawn_node(node)
	node.global_position = _aim_pos
	
	return ExecuteResult.Trigger

func start() -> CharacterPhasedAbility.StartResult:
	_context.use_visible_mouse()
	_is_started = false
	
	return CharacterPhasedAbility.StartResult.HandleWithInput

func update(_delta: float) -> void:
	var result := _context.raycast_from_mouse(_new_data.cast_range, Layers.COLLISION_WORLD)
	
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
		_context.get_animation_position(_new_data),
		_new_data.anim.cast_point,
	)
