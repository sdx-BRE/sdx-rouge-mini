class_name CharacterAbilityEffectBuff extends CharacterAbilityEffect

@export var scene: PackedScene
@export var duration: float

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecutionExecuteContext,
) -> CharacterAbilityExecutionExecuteEffectHandler:
	return CharacterAbilityExecutionExecuteBuffHandler.new(ability, context)
