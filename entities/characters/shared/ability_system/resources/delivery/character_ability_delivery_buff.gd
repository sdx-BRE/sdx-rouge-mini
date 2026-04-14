class_name CharacterAbilityDeliveryBuff extends CharacterAbilityDelivery

@export var scene: PackedScene
@export var duration: float

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteDeliveryHandler:
	return CharacterAbilityExecuteDeliveryBuffHandler.new(ability, context)
