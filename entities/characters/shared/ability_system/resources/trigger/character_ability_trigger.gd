class_name CharacterAbilityTrigger extends Resource

func create_handler(
	exec: CharacterAbilityExecuter,
	delivery: CharacterAbilityExecuteDeliveryHandler,
) -> CharacterAbilityExecuteTriggerHandler:
	return CharacterAbilityExecuteTriggerHandler.new(exec, delivery)
