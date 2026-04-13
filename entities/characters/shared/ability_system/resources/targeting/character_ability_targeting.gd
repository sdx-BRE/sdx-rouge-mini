class_name CharacterAbilityTargeting extends Resource

@export var cast_range: float
@export_enum("attack", "skill_1", "skill_2", "skill_3") var input_trigger: String

func get_strategy(context: CharacterAbilityExecutionAimingContext) -> CharacterAbilityExecutionAimingBase:
	return CharacterAbilityExecutionAimingBase.new(context)
