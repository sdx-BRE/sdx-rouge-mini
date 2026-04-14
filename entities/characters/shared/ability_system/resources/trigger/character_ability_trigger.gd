class_name CharacterAbilityTrigger extends Resource

func create_handler(
	exec: CharacterAbilityExecuter,
	effect: CharacterAbilityExecuteEffectHandler,
) -> CharacterAbilityExecuteTriggerHandler:
	return CharacterAbilityExecuteTriggerHandler.new(exec, effect)
