class_name AbilityTargetingMouseTarget extends AbilityTargetingInput

func get_strategy(context: AbilityAimingContext) -> AbilityAimingHandler:
	return AbilityAimingMouseTargetHandler.new(context)
