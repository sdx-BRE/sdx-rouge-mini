class_name CharacterAbilityTriggerCharged extends CharacterAbilityTrigger

func create_handler(
	exec: CharacterAbilityExecuter,
	effect: CharacterAbilityExecuteEffectHandler,
) -> CharacterAbilityExecuteTriggerHandler:
	return CharacterAbilityExecuteTriggerChargedHandler.new(exec, effect)
