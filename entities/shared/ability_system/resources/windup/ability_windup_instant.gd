class_name AbilityWindupInstant extends AbilityWindup

func create_setup_handler(context: AbilitySetupContext, blackboard: AbilityExecutionBlackboard) -> AbilitySetupWindupHandler:
	return AbilitySetupInstantHandler.new(context, blackboard)
