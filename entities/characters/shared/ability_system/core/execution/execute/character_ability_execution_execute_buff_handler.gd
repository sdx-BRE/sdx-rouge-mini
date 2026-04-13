class_name CharacterAbilityExecutionExecuteBuffHandler extends CharacterAbilityExecutionExecuteEffectHandler

var _data: CharacterAbilityEffectBuff

func setup(data: CharacterAbilityEffect) -> void:
	_data = data

func execute(_aiming_result: CharacterAbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	
	_setup_when_ability(node, _data)
	_use_resources()
	_ability.start_cooldown()
	
	_context.spawn_buff(node)
	_launch_when_ability(node, _data)
	
	_emit_finished()
