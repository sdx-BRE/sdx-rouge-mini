class_name AbilityDeliveryAoe extends AbilityDelivery

@export var scene: PackedScene
@export var damage: AbilityDamage
@export var delay: float = 0.75
@export var radius: float = 2.0

func create_handler(
	context: AbilityExecuteContext,
	blackboard: AbilityExecutionBlackboard,
) -> AbilityExecuteDeliveryHandler:
	return AbilityExecuteDeliveryAoeHandler.new(context, blackboard)
