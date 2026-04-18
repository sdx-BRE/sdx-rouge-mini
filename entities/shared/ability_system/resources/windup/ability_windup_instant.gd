class_name AbilityWindupInstant extends AbilityWindup

func create_setup_handler(context: AbilitySetupContext) -> AbilitySetupWindupHandler:
	return AbilitySetupInstantHandler.new(context)
