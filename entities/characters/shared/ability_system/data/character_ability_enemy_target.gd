@tool
class_name CharacterAbilityEnemyTarget extends CharacterAbilityPhased

@export var cast_range: float = 20.0
@export_enum("attack", "skill_1", "skill_2", "skill_3") var input_trigger: String

func to_ability(
	stats: EntityStats,
	context: CharacterAbilityContext,
) -> CharacterEnemyTargetAbility:
	if not context is PhasedContext:
		push_error(DbgHelper.err("CharacterAbilityEnemyTarget.to_ability()", "context MUST be PhasedContext"))
		return null
	
	return CharacterEnemyTargetAbility.create(self, stats, context)
