class_name AbilityTargetingDirectional extends AbilityTargetingInput

func get_strategy(context: AbilityAimingContext) -> AbilityAimingHandler:
	return AbilityAimingDirectionalHandler.new(context)
