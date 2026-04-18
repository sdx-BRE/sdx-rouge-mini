class_name AbilityDelivery extends Resource

func create_handler(
	context: AbilityExecuteContext,
) -> AbilityExecuteDeliveryHandler:
	return AbilityExecuteDeliveryHandler.new(context)
