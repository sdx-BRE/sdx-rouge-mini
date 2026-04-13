class_name CharacterAbilityEffectJump extends CharacterAbilityEffect

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecutionExecuteEffectHandler:
	return CharacterAbilityExecutionExecuteJumpHandler.new(ability, context)
