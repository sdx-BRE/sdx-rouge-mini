class_name AbilityDeliveryJump extends AbilityDelivery

func create_handler(
	context: AbilityExecuteContext,
	blackboard: AbilityExecutionBlackboard,
) -> AbilityExecuteDeliveryHandler:
	return AbilityExecuteDeliveryJumpHandler.new(context, blackboard)
