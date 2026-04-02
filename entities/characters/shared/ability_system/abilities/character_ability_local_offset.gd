class_name CharacterAbilityLocalOffset extends CharacterPhasedAbility

var _data: LocalOffsetAbility

func _init(context: PhasedContext, data: LocalOffsetAbility) -> void:
	super(context)
	_data = data

static func create(context: PhasedContext, data: LocalOffsetAbility) -> CharacterAbilityLocalOffset:
	context.update_cast_point(data)
	return CharacterAbilityLocalOffset.new(context, data)

func execute() -> ExecuteResult:
	_context.notify_casting_end()
	var node := _data.scene.instantiate()
	_context.spawn_node(node)
	
	var spawn_transform := _context.get_wand_transform()
	node.global_transform = spawn_transform.translated_local(_data.offset)
	
	var corrected_basis := _context.get_pivot_basis().rotated(Vector3.UP, PI)
	node.global_basis = corrected_basis
	
	return ExecuteResult.Trigger

func start() -> CharacterPhasedAbility.StartResult:
	_context.animate(_data.anim)
	_context.notify_casting_started()
	
	return CharacterPhasedAbility.StartResult.BufferAbility

func tick_cast(_delta: float) -> void:
	_context.notify_casting_progressed(
		_context.get_animation_position(_data.anim),
		_data.anim.cast_point,
	)

func _get_cost() -> AbilityCost:
	return _data.cost
