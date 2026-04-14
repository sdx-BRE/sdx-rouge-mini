class_name CharacterAbilityDeliveryBuff extends CharacterAbilityDelivery

@export var scene: PackedScene
@export var duration: float

func create_handler(
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteDeliveryHandler:
	return CharacterAbilityExecuteDeliveryBuffHandler.new(context)
