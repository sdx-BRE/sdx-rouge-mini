@tool
class_name CharacterAbilityJump extends CharacterAbilityData

func to_ability(
	stats: EntityStats,
	context: CharacterAbilityContext,
) -> CharacterJumpAbility:
	if not context is InstantContext:
		push_error(DbgHelper.err("CharacterAbilityJump.to_ability()", "context MUST be InstantContext"))
		return null
	
	return CharacterJumpAbility.new(self, stats, context)
