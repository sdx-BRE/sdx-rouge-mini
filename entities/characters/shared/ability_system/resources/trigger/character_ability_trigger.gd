class_name CharacterAbilityTrigger extends Resource

func create_handler(
	exec: CharacterAbilityExecution,
	effect: CharacterAbilityExecutionExecuteEffectHandler,
) -> CharacterAbilityTriggerHandler:
	return CharacterAbilityTriggerHandler.new(exec, effect)
