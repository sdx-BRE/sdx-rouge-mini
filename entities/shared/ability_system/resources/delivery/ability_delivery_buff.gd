class_name AbilityDeliveryBuff extends AbilityDelivery

@export var scene: PackedScene
@export var duration: float

func create_handler(
	context: AbilityExecuteContext,
	blackboard: AbilityExecutionBlackboard,
) -> AbilityExecuteDeliveryHandler:
	return AbilityExecuteDeliveryBuffHandler.new(context, blackboard)
