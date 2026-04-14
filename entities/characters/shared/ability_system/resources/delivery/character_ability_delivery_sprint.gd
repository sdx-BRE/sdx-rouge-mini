class_name CharacterAbilityDeliverySprint extends CharacterAbilityDelivery

func create_handler(
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteDeliveryHandler:
	return CharacterAbilityExecuteDeliverySprintHandler.new(context)
