class_name CharacterAbilityDeliveryContinuous extends CharacterAbilityDelivery

@export var scene: PackedScene
@export var damage := 10.0

func create_handler(
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteDeliveryHandler:
	return CharacterAbilityExecuteDeliveryContinuousHandler.new(context)
