class_name CharacterEnemyTargetAbility extends CharacterPhasedAbility

var _new_data: CharacterAbilityEnemyTarget

var _target: Node3D
var _is_started := false

func _init(data: CharacterAbilityEnemyTarget, stats: EntityStats, context: PhasedContext) -> void:
	super(data, stats, context)
	_new_data = data

static func create(data: CharacterAbilityEnemyTarget, stats: EntityStats, context: PhasedContext) -> CharacterEnemyTargetAbility:
	context.update_cast_point(data)
	return CharacterEnemyTargetAbility.new(data, stats, context)

func execute() -> ExecuteResult:
	if _target == null:
		return ExecuteResult.Cancel
	
	_context.notify_casting_end()
	_context.use_captured_mouse()
	_context.hide_enemy_target_marker()
	
	var node := _new_data.scene.instantiate()
	_spawn_ability(node)
	
	return ExecuteResult.Trigger

func _spawn_ability(node: Node3D):
	_context.spawn_at_wand(node)
	node.global_basis = _context.get_pivot_basis()
	
	if node.has_method("set_target"):
		var target = _target.get_target_point() if _target.has_method("get_target_point") else _target
		node.set_target(target)
	
	if "damage" in node:
		node.damage = _data.damage

func start() -> CharacterPhasedAbility.StartResult:
	_context.use_visible_mouse(Cursor.Type.Attack)
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
	var is_cancel_pressed := event.is_action_pressed("ui_cancel")
	var is_action_pressed_again := _is_started and event.is_action(_new_data.input)
	
	var is_canceled := is_cancel_pressed or is_action_pressed_again
	if is_canceled:
		return HandleInputResult.Cancel
	
	if event.is_action_released(_new_data.input):
		_is_started = true
	
	if event.is_action_pressed(_new_data.input_trigger):
		if _target == null:
			return HandleInputResult.Cancel
		
		_context.animate(_new_data)
		_context.use_captured_mouse()
		_context.notify_casting_started()
		return HandleInputResult.Trigger
	
	return HandleInputResult.Unhandled

func cancel() -> void:
	_context.use_captured_mouse()
	_context.hide_enemy_target_marker()
