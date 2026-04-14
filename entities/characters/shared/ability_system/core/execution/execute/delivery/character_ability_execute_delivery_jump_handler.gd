class_name CharacterAbilityExecuteDeliveryJumpHandler extends CharacterAbilityExecuteDeliveryHandler

var _data: CharacterAbilityDeliveryJump

func setup(data: CharacterAbilityDelivery) -> void:
	_data = data

func execute(_aiming_result: CharacterAbilityAimingResult) -> void:
	_context.buffer_jump()
