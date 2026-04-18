class_name AbilityExecuteDeliveryJumpHandler extends AbilityExecuteDeliveryHandler

var _data: AbilityDeliveryJump

func setup(data: AbilityDelivery) -> void:
	_data = data

func execute(_aiming_result: AbilityAimingResult) -> void:
	_context.buffer_jump()
