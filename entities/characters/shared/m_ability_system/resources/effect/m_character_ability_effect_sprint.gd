class_name MCharacterAbilityEffectSprint extends MCharacterAbilityEffect

func create_handler(
	ability: MCharacterAbility,
	context: MCharacterAbilityExecutionExecuteContext,
) -> MCharacterAbilityExecutionExecuteEffectHandler:
	return MCharacterAbilityExecutionExecuteSprintHandler.new(ability, context)
