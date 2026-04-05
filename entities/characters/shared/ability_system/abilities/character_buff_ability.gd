class_name CharacterBuffAbility extends CharacterPhasedAbility

var _buff_data: CharacterAbilityBuff

func _init(data: CharacterAbilityBuff, stats: EntityStats, context: PhasedContext) -> void:
	super(data, stats, context)
	_buff_data = data

func start() -> StartResult:
	_context.animate(_buff_data)
	return StartResult.BufferAbility

func execute() -> ExecuteResult:
	_context.notify_casting_end()
	var node := _buff_data.scene.instantiate()
	if not node is AbilityEntity:
		push_error(DbgHelper.err("CharacterBuffAbility.execute", "instantiated scene is NOT AbilityEntity, ability id: '%d'" % _data.id))
		return ExecuteResult.Cancel
	
	_spawn_buff(node)
	
	return ExecuteResult.Trigger

func _spawn_buff(node: AbilityEntity) -> void:
	node.setup_character_ability(_buff_data, _context)
	_context.spawn_buff(node)
	node.launch_character_ability(_buff_data, _context)

func cancel() -> void: pass
