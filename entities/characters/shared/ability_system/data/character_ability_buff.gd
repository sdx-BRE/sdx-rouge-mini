@tool
class_name CharacterAbilityBuff extends CharacterAbilityPhased

@export var duration: float = 2.0

func to_ability(
	stats: EntityStats,
	context: CharacterAbilityContext,
) -> CharacterBuffAbility:
	if not context is PhasedContext:
		push_error(DbgHelper.err("CharacterAbilityBuff.to_ability()", "context MUST be PhasedContext"))
		return null
	
	return CharacterBuffAbility.new(self, stats, context)
