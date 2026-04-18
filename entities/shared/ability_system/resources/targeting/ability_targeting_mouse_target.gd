class_name AbilityTargetingMouseTarget extends AbilityTargeting

func get_strategy(context: AbilityAimingContext) -> AbilityAimingHandler:
	return AbilityAimingMouseTargetHandler.new(context)
