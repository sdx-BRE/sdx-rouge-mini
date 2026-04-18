class_name AbilityDeliveryDash extends AbilityDelivery

@export var dash_power: float = 15.0

func create_handler(
	context: AbilityExecuteContext,
) -> AbilityExecuteDeliveryHandler:
	return AbilityExecuteDeliveryDashHandler.new(context)
