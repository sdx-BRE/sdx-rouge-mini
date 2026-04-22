class_name AbilityDeliverySprint extends AbilityDelivery

func create_handler(
	context: AbilityExecuteContext,
	blackboard: AbilityExecutionBlackboard,
) -> AbilityExecuteDeliveryHandler:
	return AbilityExecuteDeliverySprintHandler.new(context, blackboard)
