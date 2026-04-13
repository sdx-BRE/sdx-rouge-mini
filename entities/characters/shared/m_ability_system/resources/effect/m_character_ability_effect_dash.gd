class_name MCharacterAbilityEffectDash extends MCharacterAbilityEffect

@export var dash_power: float = 15.0

func create_handler(
	ability: MCharacterAbility,
	context: MCharacterAbilityExecutionExecuteContext,
) -> MCharacterAbilityExecutionExecuteEffectHandler:
	return MCharacterAbilityExecutionExecuteDashHandler.new(ability, context)
