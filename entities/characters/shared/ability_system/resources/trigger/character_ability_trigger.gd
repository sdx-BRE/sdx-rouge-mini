class_name CharacterAbilityTrigger extends Resource

func create_handler(
	blackboard: CharacterAbilityExecutionBlackboard,
) -> CharacterAbilityExecuteTriggerHandler:
	return CharacterAbilityExecuteTriggerHandler.new(blackboard)
