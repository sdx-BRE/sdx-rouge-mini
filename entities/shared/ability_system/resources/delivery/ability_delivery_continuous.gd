class_name AbilityDeliveryContinuous extends AbilityDelivery

@export var scene: PackedScene
@export var damage: AbilityDamage

func create_handler(
	context: AbilityExecuteContext,
	blackboard: AbilityExecutionBlackboard,
) -> AbilityExecuteDeliveryHandler:
	return AbilityExecuteDeliveryContinuousHandler.new(context, blackboard)
