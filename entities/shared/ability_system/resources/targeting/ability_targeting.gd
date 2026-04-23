class_name AbilityTargeting extends Resource

func get_strategy(context: AbilityAimingContext) -> AbilityAimingHandler:
	return AbilityAimingHandler.new(context)
