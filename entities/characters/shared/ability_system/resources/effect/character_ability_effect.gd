class_name CharacterAbilityEffect extends Resource

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteEffectHandler:
	return CharacterAbilityExecuteEffectHandler.new(ability, context)
