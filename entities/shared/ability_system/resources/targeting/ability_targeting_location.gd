class_name AbilityTargetingLocation extends AbilityTargetingInput

func get_strategy(context: AbilityAimingContext) -> AbilityAimingHandler:
	return AbilityAimingLocationHandler.new(context)
