class_name CharacterAbilityDelivery extends Resource

func create_handler(
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteDeliveryHandler:
	return CharacterAbilityExecuteDeliveryHandler.new(context)
