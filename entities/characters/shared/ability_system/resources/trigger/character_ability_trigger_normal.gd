class_name CharacterAbilityTriggerNormal extends CharacterAbilityTrigger

func create_handler(
	exec: CharacterAbilityExecuter,
	delivery: CharacterAbilityExecuteDeliveryHandler,
) -> CharacterAbilityExecuteTriggerHandler:
	return CharacterAbilityExecuteTriggerNormalHandler.new(exec, delivery)
