class_name CharacterLocalOffsetAbility extends CharacterPhasedAbility

var _new_data: CharacterAbilityLocalOffset

func _init(context: PhasedContext, new_data: CharacterAbilityLocalOffset) -> void:
	super(new_data, context)
	_new_data = new_data

static func create(context: PhasedContext, new_data: CharacterAbilityLocalOffset) -> CharacterLocalOffsetAbility:
	context.update_cast_point(new_data)
	return CharacterLocalOffsetAbility.new(context, new_data)

func execute() -> ExecuteResult:
	_context.notify_casting_end()
	var node := _new_data.scene.instantiate()
	_context.spawn_node(node)
	
	var player_basis := _context.get_pivot_basis()
	var wand_pos := _context.get_wandspawn_position()
	
	var final_transform := Transform3D(player_basis, wand_pos)
	final_transform = final_transform.translated_local(_new_data.offset)
	
	node.global_transform = final_transform
	
	return ExecuteResult.Trigger

func start() -> CharacterPhasedAbility.StartResult:
	_context.animate(_new_data)
	_context.notify_casting_started()
	
	return CharacterPhasedAbility.StartResult.BufferAbility

func tick_cast(_delta: float) -> void:
	_context.notify_casting_progressed(
		_context.get_animation_position(_new_data),
		_new_data.anim.cast_point,
	)
