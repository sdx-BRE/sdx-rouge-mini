@tool
class_name CharacterAbilityLocalOffset extends CharacterAbilityPhased

@export var offset: Vector3 = Vector3.ZERO

func to_ability(
	stats: EntityStats,
	context: CharacterAbilityContext,
) -> CharacterLocalOffsetAbility:
	if not context is PhasedContext:
		push_error(DbgHelper.err("CharacterAbilityLocalOffset.to_ability()", "context MUST be PhasedContext"))
		return null
	
	return CharacterLocalOffsetAbility.create(self, stats, context)
