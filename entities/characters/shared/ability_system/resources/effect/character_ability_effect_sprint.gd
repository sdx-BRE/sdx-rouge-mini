class_name CharacterAbilityEffectSprint extends CharacterAbilityEffect

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecutionExecuteEffectHandler:
	return CharacterAbilityExecutionExecuteSprintHandler.new(ability, context)
