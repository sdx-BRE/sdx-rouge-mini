class_name CharacterAbilityEffectDash extends CharacterAbilityEffect

@export var dash_power: float = 15.0

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecutionExecuteContext,
) -> CharacterAbilityExecutionExecuteEffectHandler:
	return CharacterAbilityExecutionExecuteDashHandler.new(ability, context)
