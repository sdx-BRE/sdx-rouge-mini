class_name AbilityTriggerCharged extends AbilityTrigger

func create_handler(
	blackboard: AbilityExecutionBlackboard,
) -> AbilityExecuteTriggerHandler:
	return AbilityExecuteTriggerChargedHandler.new(blackboard)
