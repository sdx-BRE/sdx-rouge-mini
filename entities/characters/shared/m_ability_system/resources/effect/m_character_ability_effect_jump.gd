class_name MCharacterAbilityEffectJump extends MCharacterAbilityEffect

func create_handler(
	ability: MCharacterAbility,
	context: MCharacterAbilityExecutionExecuteContext,
) -> MCharacterAbilityExecutionExecuteEffectHandler:
	return MCharacterAbilityExecutionExecuteJumpHandler.new(ability, context)
