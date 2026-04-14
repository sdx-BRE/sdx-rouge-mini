class_name CharacterAbilityDeliveryJump extends CharacterAbilityDelivery

func create_handler(
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteDeliveryHandler:
	return CharacterAbilityExecuteDeliveryJumpHandler.new(context)
