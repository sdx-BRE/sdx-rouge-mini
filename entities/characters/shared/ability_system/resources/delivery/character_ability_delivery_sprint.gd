class_name CharacterAbilityDeliverySprint extends CharacterAbilityDelivery

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteDeliveryHandler:
	return CharacterAbilityExecuteDeliverySprintHandler.new(ability, context)
