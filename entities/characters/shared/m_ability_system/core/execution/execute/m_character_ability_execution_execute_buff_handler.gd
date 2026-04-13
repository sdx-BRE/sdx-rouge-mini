class_name MCharacterAbilityExecutionExecuteBuffHandler extends MCharacterAbilityExecutionExecuteEffectHandler

var _data: MCharacterAbilityEffectBuff

func setup(data: MCharacterAbilityEffect) -> void:
	_data = data

func execute(_aiming_result: McharacterAbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	
	_setup_when_ability(node, _data)
	_use_resources()
	_ability.start_cooldown()
	
	_context.spawn_buff(node)
	_launch_when_ability(node, _data)
	
	_emit_finished()
