class_name CharacterAbilityExecutionExecuteJumpHandler extends CharacterAbilityExecutionExecuteEffectHandler

var _data: CharacterAbilityEffectJump

func setup(data: CharacterAbilityEffect) -> void:
	_data = data

func execute(_aiming_result: CharacterAbilityAimingResult) -> void:
	_context.buffer_jump()
