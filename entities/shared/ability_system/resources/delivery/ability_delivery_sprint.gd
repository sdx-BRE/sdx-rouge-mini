class_name AbilityDeliverySprint extends AbilityDelivery

func create_handler(
	context: AbilityExecuteContext,
) -> AbilityExecuteDeliveryHandler:
	return AbilityExecuteDeliverySprintHandler.new(context)
