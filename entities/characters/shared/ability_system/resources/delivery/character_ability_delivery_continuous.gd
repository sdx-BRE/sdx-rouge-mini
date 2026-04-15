class_name CharacterAbilityDeliveryContinuous extends CharacterAbilityDelivery

@export var scene: PackedScene

func create_handler(
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteDeliveryHandler:
	return CharacterAbilityExecuteDeliveryContinuousHandler.new(context)
