class_name AbilityTargetingAI extends AbilityTargeting

func get_strategy(context: AbilityAimingContext) -> AbilityAimingHandler:
	return AbilityAimingAIHandler.new(context)
