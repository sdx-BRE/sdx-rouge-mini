class_name AbilityTriggerNormal extends AbilityTrigger

func create_handler(
	blackboard: AbilityExecutionBlackboard,
) -> AbilityExecuteTriggerHandler:
	return AbilityExecuteTriggerNormalHandler.new(blackboard)
