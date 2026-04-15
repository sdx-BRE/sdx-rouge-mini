class_name CharacterAbilityTriggerChanneled extends CharacterAbilityTrigger

@export var tick_rate: float = 0.05

func create_handler(
	blackboard: CharacterAbilityExecutionBlackboard,
) -> CharacterAbilityExecuteTriggerHandler:
	return CharacterAbilityExecuteTriggerChanneledHandler.new(blackboard)
