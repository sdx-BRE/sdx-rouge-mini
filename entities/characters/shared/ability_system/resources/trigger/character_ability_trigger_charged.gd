class_name CharacterAbilityTriggerCharged extends CharacterAbilityTrigger

func create_handler(
	exec: CharacterAbilityExecution,
	effect: CharacterAbilityExecutionExecuteEffectHandler,
) -> CharacterAbilityTriggerHandler:
	return CharacterAbilityTriggerChargedHandler.new(exec, effect)
