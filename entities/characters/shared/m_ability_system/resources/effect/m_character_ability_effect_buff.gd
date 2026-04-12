class_name MCharacterAbilityEffectBuff extends MCharacterAbilityEffect

@export var scene: PackedScene
@export var duration: float

func create_handler(context: MCharacterAbilityExecutionExecuteContext) -> MCharacterAbilityExecutionExecuteEffectHandler:
	return MCharacterAbilityExecutionExecuteBuffHandler.new(context)
