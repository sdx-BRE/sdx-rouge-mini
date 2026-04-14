class_name CharacterAbilityTriggerChanneled extends CharacterAbilityTrigger

func create_handler(
	exec: CharacterAbilityExecuter,
	effect: CharacterAbilityExecuteEffectHandler,
) -> CharacterAbilityExecuteTriggerHandler:
	return CharacterAbilityExecuteTriggerChanneledHandler.new(exec, effect)
