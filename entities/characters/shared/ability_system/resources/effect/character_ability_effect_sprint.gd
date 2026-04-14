class_name CharacterAbilityEffectSprint extends CharacterAbilityEffect

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteEffectHandler:
	return CharacterAbilityExecuteEffectSprintHandler.new(ability, context)
