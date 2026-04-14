class_name CharacterAbilityEffectBuff extends CharacterAbilityEffect

@export var scene: PackedScene
@export var duration: float

func create_handler(
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> CharacterAbilityExecuteEffectHandler:
	return CharacterAbilityExecuteEffectBuffHandler.new(ability, context)
