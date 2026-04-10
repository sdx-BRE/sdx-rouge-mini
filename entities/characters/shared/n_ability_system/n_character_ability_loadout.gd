class_name NCharacterAbilityLoadout extends RefCounted

var _registry: NCharacterAbilityRegistry
var _stats: EntityStats

func _init(
	registry: NCharacterAbilityRegistry,
	stats: EntityStats,
) -> void:
	_registry = registry
	_stats = stats

func grant_ability(data: NCharacterAbilityData) -> void:
	var ability := data.to_ability(_stats, null) # Todo: fixme
	_registry.add(data.id, ability)

