class_name CharacterAbilityFactory extends RefCounted

var _stats: EntityStats
var _phased_context: PhasedContext
var _instant_context: InstantContext
var _channeled_context: ChanneledContext

func _init(
	stats: EntityStats,
	phased_context: PhasedContext,
	instant_context: InstantContext,
	channeled_context: ChanneledContext,
) -> void:
	_stats = stats
	_phased_context = phased_context
	_instant_context = instant_context
	_channeled_context = channeled_context

func create_ability(data: CharacterAbilityData) -> CharacterAbility:
	var context := _resolve_context(data)
	if context == null:
		push_error(DbgHelper.err("CharacterAbilityFactory.create_ability", "Failed to resolve context for ability (id: %d)" % data.id))
		return null
	
	return data.to_ability(_stats, context)

func _resolve_context(data: CharacterAbilityData) -> CharacterAbilityContext:
	if data is CharacterAbilityPhased:
		return _phased_context
	
	if data is CharacterAbilityInstant:
		return _instant_context
	
	if data is CharacterAbilityChanneled:
		return _channeled_context
	
	return null
