class_name MCharacterAbilityEffect extends Resource

func create_handler(
	ability: MCharacterAbility,
	context: MCharacterAbilityExecutionExecuteContext,
) -> MCharacterAbilityExecutionExecuteEffectHandler:
	return MCharacterAbilityExecutionExecuteEffectHandler.new(ability, context)
