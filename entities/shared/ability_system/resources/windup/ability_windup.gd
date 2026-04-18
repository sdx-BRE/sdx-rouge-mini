class_name AbilityWindup extends Resource

func create_setup_handler(context: AbilitySetupContext) -> AbilitySetupWindupHandler:
	return AbilitySetupWindupHandler.new(context)

func create_recover_handler(context: AbilityRecoverContext) -> AbilityRecoverWindupHandler:
	return AbilityRecoverWindupHandler.new(context)
