@tool
class_name CharacterAbilitySprint extends CharacterAbilityChanneled

func to_ability(
	stats: EntityStats,
	context: CharacterAbilityContext,
) -> CharacterSprintAbility:
	if not context is ChanneledContext:
		push_error(DbgHelper.err("CharacterAbilityJump.to_ability()", "context MUST be ChanneledContext"))
		return null
	
	return CharacterSprintAbility.new(self, stats, context)
