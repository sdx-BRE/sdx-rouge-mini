class_name MCharacterAbilityExecutionExecuteBuffHandler extends MCharacterAbilityExecutionExecuteEffectHandler

var _data: MCharacterAbilityEffectBuff

func setup(data: MCharacterAbilityEffect) -> void:
	_data = data

func execute(_aiming_result: McharacterAbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	
	_when_ability(node, _setup_ability)
	_context.spawn_buff(node)
	_when_ability(node, _launch_ability)
	
	_emit_finished()

func _setup_ability(ability: AbilityEntity) -> void:
	ability.setup_mcharacter_ability(_data, _context)

func _launch_ability(ability: AbilityEntity) -> void:
	ability.launch_mcharacter_ability(_data, _context)

func _when_ability(node: Node, then: Callable) -> void:
	if node is AbilityEntity:
		then.call(node)
