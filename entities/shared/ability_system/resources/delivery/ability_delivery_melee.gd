class_name AbilityDeliveryMelee extends AbilityDelivery

@export var damage: AbilityDamage
@export var hit_effects: Array[PackedScene]

func create_handler(context: AbilityExecuteContext, blackboard: AbilityExecutionBlackboard) -> AbilityExecuteDeliveryHandler:
	return AbilityExecuteDeliveryMeleeHandler.new(context, blackboard)
