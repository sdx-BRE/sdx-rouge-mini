class_name AbilityTargeting extends Resource

@export var cast_range: float
@export_enum("attack", "skill_1", "skill_2", "skill_3") var input_trigger: String

func get_strategy(context: AbilityAimingContext) -> AbilityAimingHandler:
	return AbilityAimingHandler.new(context)
