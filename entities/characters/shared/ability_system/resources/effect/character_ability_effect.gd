class_name CharacterAbilityEffect extends Resource

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecutionExecuteEffectHandler:
	return CharacterAbilityExecutionExecuteEffectHandler.new(ability, context)
