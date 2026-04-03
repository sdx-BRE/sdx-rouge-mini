@tool
class_name CharacterAbilityDash extends CharacterAbilityData

@export var dash_power: float = 60.0
@export var anim_trigger: StringName

func to_ability(
	stats: EntityStats,
	context: CharacterAbilityContext,
) -> CharacterDashAbility:
	if not context is InstantContext:
		push_error(DbgHelper.err("CharacterAbilityDash.to_ability()", "context MUST be InstantContext"))
		return null
	
	return CharacterDashAbility.new(self, stats, context)
