class_name CharacterAbilityContext extends RefCounted

var _stats: EntityStats

func _init(
	stats: EntityStats,
) -> void:
	_stats = stats

func has_resources(cost: AbilityCost) -> bool:
	return _stats.has_mana(cost.mana) and _stats.has_stamina(cost.stamina)

func use_resources(cost: AbilityCost) -> void:
	_stats.use_mana(cost.mana)
	_stats.use_stamina(cost.stamina)
