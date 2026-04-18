class_name AbilityTargetingLocation extends AbilityTargeting

func get_strategy(context: AbilityAimingContext) -> AbilityAimingHandler:
	return AbilityAimingLocationHandler.new(context)
