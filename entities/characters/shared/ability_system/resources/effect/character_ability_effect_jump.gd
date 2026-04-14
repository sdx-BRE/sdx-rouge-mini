class_name CharacterAbilityEffectJump extends CharacterAbilityEffect

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteEffectHandler:
	return CharacterAbilityExecuteEffectJumpHandler.new(ability, context)
