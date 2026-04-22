class_name AbilityWindup extends Resource

func create_setup_handler(context: AbilitySetupContext, blackboard: AbilityExecutionBlackboard) -> AbilitySetupWindupHandler:
	return AbilitySetupWindupHandler.new(context, blackboard)

func create_recover_handler(context: AbilityRecoverContext) -> AbilityRecoverWindupHandler:
	return AbilityRecoverWindupHandler.new(context)
