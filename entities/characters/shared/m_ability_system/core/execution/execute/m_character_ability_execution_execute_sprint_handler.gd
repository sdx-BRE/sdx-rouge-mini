class_name MCharacterAbilityExecutionExecuteSprintHandler extends MCharacterAbilityExecutionExecuteEffectHandler

var _data: MCharacterAbilityEffectSprint

func setup(data: MCharacterAbilityEffect) -> void:
	_data = data

func execute(_aiming_result: McharacterAbilityAimingResult) -> void:
	_context.use_sprinting_speed()

func release() -> void:
	_context.use_normal_speed()
	_emit_finished()
