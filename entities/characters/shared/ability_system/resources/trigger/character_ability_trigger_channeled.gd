class_name CharacterAbilityTriggerChanneled extends CharacterAbilityTrigger

func create_handler(
	exec: CharacterAbilityExecution,
	effect: CharacterAbilityExecutionExecuteEffectHandler,
) -> CharacterAbilityTriggerHandler:
	return CharacterAbilityTriggerChanneledHandler.new(exec, effect)
