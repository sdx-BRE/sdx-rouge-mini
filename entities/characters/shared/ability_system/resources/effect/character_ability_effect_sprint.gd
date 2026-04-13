class_name CharacterAbilityEffectSprint extends CharacterAbilityEffect

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecutionExecuteContext,
) -> CharacterAbilityExecutionExecuteEffectHandler:
	return CharacterAbilityExecutionExecuteSprintHandler.new(ability, context)
