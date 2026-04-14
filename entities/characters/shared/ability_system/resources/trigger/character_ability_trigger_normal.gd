class_name CharacterAbilityTriggerNormal extends CharacterAbilityTrigger

func create_handler(
	exec: CharacterAbilityExecution,
	effect: CharacterAbilityExecutionExecuteEffectHandler,
) -> CharacterAbilityTriggerHandler:
	return CharacterAbilityTriggerNormalHandler.new(exec, effect)
