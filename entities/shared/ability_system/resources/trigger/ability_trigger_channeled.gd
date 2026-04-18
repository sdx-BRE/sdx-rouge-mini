class_name AbilityTriggerChanneled extends AbilityTrigger

@export var tick_rate: float = 0.05

func create_handler(
	blackboard: AbilityExecutionBlackboard,
) -> AbilityExecuteTriggerHandler:
	return AbilityExecuteTriggerChanneledHandler.new(blackboard)
