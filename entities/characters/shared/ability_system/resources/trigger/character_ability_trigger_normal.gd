class_name CharacterAbilityTriggerNormal extends CharacterAbilityTrigger

func create_handler(
	exec: CharacterAbilityExecuter,
	effect: CharacterAbilityExecuteEffectHandler,
) -> CharacterAbilityExecuteTriggerHandler:
	return CharacterAbilityExecuteTriggerNormalHandler.new(exec, effect)
