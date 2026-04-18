class_name AbilityDeliveryJump extends AbilityDelivery

func create_handler(
	context: AbilityExecuteContext,
) -> AbilityExecuteDeliveryHandler:
	return AbilityExecuteDeliveryJumpHandler.new(context)
