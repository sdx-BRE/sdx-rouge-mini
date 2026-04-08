class_name CharacterGroundTargetAbility extends CharacterPhasedAbility

var _new_data: CharacterAbilityGroundTarget

var _aim_pos := Vector3.ZERO
var _is_started := false

func _init(data: CharacterAbilityGroundTarget, stats: EntityStats, context: PhasedContext) -> void:
	super(data, stats, context)
	_new_data = data

static func create(data: CharacterAbilityGroundTarget, stats: EntityStats, context: PhasedContext) -> CharacterGroundTargetAbility:
	context.update_cast_point(data)
	return CharacterGroundTargetAbility.new(data, stats, context)

func execute() -> ExecuteResult:
	_context.notify_casting_end()
	
	var node := _new_data.scene.instantiate()
	_context.spawn_node(node)
	node.global_position = _aim_pos
	
	return ExecuteResult.Trigger

func start() -> CharacterPhasedAbility.StartResult:
	_context.use_visible_mouse(Cursor.Type.Pointer)
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
	var is_cancel_pressed := event.is_action_pressed("ui_cancel")
	var is_action_pressed_again := _is_started and event.is_action(_new_data.input)
	
	var is_canceled := is_cancel_pressed or is_action_pressed_again
	if is_canceled:
		return HandleInputResult.Cancel
	
	if event.is_action_released(_new_data.input):
		_is_started = true
	
	if event.is_action_pressed(_new_data.input_trigger):
		_context.animate(_new_data)
		_context.use_captured_mouse()
		_context.hide_ground_target_marker()
		_context.notify_casting_started()
		
		return HandleInputResult.Trigger
	
	return HandleInputResult.Unhandled

func cancel() -> void:
	_context.use_captured_mouse()
	_context.hide_ground_target_marker()
