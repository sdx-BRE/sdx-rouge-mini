class_name CharacterAbilityDeliveryJump extends CharacterAbilityDelivery

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteDeliveryHandler:
	return CharacterAbilityExecuteDeliveryJumpHandler.new(ability, context)
