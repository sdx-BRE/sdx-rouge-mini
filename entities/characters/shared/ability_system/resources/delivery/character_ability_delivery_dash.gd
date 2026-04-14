class_name CharacterAbilityDeliveryDash extends CharacterAbilityDelivery

@export var dash_power: float = 15.0

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteDeliveryHandler:
	return CharacterAbilityExecuteDeliveryDashHandler.new(ability, context)
