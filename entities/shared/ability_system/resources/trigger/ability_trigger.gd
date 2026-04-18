class_name AbilityTrigger extends Resource

func create_handler(
	blackboard: AbilityExecutionBlackboard,
) -> AbilityExecuteTriggerHandler:
	return AbilityExecuteTriggerHandler.new(blackboard)
