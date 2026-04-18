class_name AbilityDeliveryContinuous extends AbilityDelivery

@export var scene: PackedScene
@export var damage := 10.0

func create_handler(
	context: AbilityExecuteContext,
) -> AbilityExecuteDeliveryHandler:
	return AbilityExecuteDeliveryContinuousHandler.new(context)
