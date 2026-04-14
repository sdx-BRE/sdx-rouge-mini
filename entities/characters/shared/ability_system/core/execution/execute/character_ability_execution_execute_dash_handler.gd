class_name CharacterAbilityExecutionExecuteDashHandler extends CharacterAbilityExecutionExecuteEffectHandler

var _data: CharacterAbilityEffectDash

func setup(data: CharacterAbilityEffect) -> void:
	_data = data

func execute(_aiming_result: CharacterAbilityAimingResult) -> void:
	_use_resources()
	_ability.start_cooldown()
	
	_context.push_dash_motion(_data.dash_power)
