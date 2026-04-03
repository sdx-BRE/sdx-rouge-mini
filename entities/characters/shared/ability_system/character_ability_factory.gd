class_name CharacterAbilityFactory extends RefCounted

var _stats: EntityStats
var _phased_context: PhasedContext
var _instant_context: InstantContext

func _init(
	stats: EntityStats,
	phased_context: PhasedContext,
	instant_context: InstantContext,
) -> void:
	_stats = stats
	_phased_context = phased_context
	_instant_context = instant_context

func create_ability(data: CharacterAbilityData) -> CharacterAbility:
	var context := _resolve_context(data)
	if context == null:
		push_error(DbgHelper.err("CharacterAbilityFactory.create_ability", "Failed to resolve context for ability (id: %d)" % data.id))
		return null
	
	return data.to_ability(_stats, context)

func _resolve_context(data: CharacterAbilityData) -> CharacterAbilityContext:
	if data is CharacterAbilityEnemyTarget \
		or data is CharacterAbilityGroundTarget \
		or data is CharacterAbilityLocalOffset:
		return _phased_context
	elif data is CharacterAbilityJump \
		or data is CharacterAbilityDash:
		return _instant_context
	
	return null
