class_name CharacterAbilityEnemyTarget extends CharacterPhasedAbility

var _data: EnemyTargetAbility

var _target: Node3D
var _is_started := false

func _init(context: PhasedContext, data: EnemyTargetAbility) -> void:
	super(context)
	_data = data

static func create(context: PhasedContext, data: EnemyTargetAbility) -> CharacterAbilityEnemyTarget:
	context.update_cast_point(data)
	return CharacterAbilityEnemyTarget.new(context, data)

func execute() -> ExecuteResult:
	if _target == null:
		return ExecuteResult.Cancel
	
	_context.notify_casting_end()
	_context.use_captured_mouse()
	_context.hide_enemy_target_marker()
	
	var node := _data.scene.instantiate()
	_context.spawn_at_wand(node)
	
	if node.has_method("set_target"):
		var target = _target.get_target_point() if _target.has_method("get_target_point") else _target
		node.set_target(target)
	
	return ExecuteResult.Trigger

func start() -> CharacterPhasedAbility.StartResult:
	_context.use_visible_mouse()
	_is_started = false
	
	return CharacterPhasedAbility.StartResult.HandleWithInput

func update(_delta: float) -> void:
	var cast_range := 120.0
	var result := _context.raycast_from_mouse(cast_range, Layers.COLLISION_ENEMY_COLLISION)
	
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

func handle_input(event: InputEvent) -> HandleInputResult:
	var is_cancel_pressed := event.is_action_pressed(MageAbilityActions.ACTION_CANCEL)
	var is_action_pressed_again := _is_started and event.is_action(MageAbilityActions.ACTION_FIREBOLT)
	
	var is_canceled := is_cancel_pressed or is_action_pressed_again
	if is_canceled:
		return HandleInputResult.Cancel
	
	if event.is_action_released(MageAbilityActions.ACTION_FIREBOLT):
		_is_started = true
	
	if event.is_action_pressed(MageAbilityActions.ACTION_ATTACK):
		if _target == null:
			return HandleInputResult.Cancel
		
		_context.animate(_data.anim)
		_context.use_captured_mouse()
		_context.notify_casting_started()
		return HandleInputResult.Trigger
	
	return HandleInputResult.Unhandled

func cancel() -> void:
	_context.use_captured_mouse()
	_context.hide_enemy_target_marker()

func tick_cast(_delta: float) -> void:
	_context.notify_casting_progressed(
		_context.get_animation_position(_data.anim),
		_data.anim.cast_point,
	)

func _get_cost() -> AbilityCost:
	return _data.cost
