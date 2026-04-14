class_name CharacterAbilityTriggerCharged extends CharacterAbilityTrigger

func create_handler(
	exec: CharacterAbilityExecuter,
	delivery: CharacterAbilityExecuteDeliveryHandler,
) -> CharacterAbilityExecuteTriggerHandler:
	return CharacterAbilityExecuteTriggerChargedHandler.new(exec, delivery)
