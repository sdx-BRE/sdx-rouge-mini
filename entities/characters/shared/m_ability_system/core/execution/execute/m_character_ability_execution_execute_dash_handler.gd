class_name MCharacterAbilityExecutionExecuteDashHandler extends MCharacterAbilityExecutionExecuteEffectHandler

var _data: MCharacterAbilityEffectDash

func setup(data: MCharacterAbilityEffect) -> void:
	_data = data

func execute(_aiming_result: McharacterAbilityAimingResult) -> void:
	_use_resources()
	_context.push_dash_motion(_data.dash_power)
	_emit_finished()
