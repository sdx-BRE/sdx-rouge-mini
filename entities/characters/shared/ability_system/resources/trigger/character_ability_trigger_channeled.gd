class_name CharacterAbilityTriggerChanneled extends CharacterAbilityTrigger

func create_handler(
	exec: CharacterAbilityExecuter,
	delivery: CharacterAbilityExecuteDeliveryHandler,
) -> CharacterAbilityExecuteTriggerHandler:
	return CharacterAbilityExecuteTriggerChanneledHandler.new(exec, delivery)
