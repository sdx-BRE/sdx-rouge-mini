class_name AbilityContext extends RefCounted

var _stats: EntityStats

func _init(stats: EntityStats) -> void:
	_stats = stats

func has_mana(cost: AbilityCost) -> bool:
	return _stats.has_mana(cost.mana)

func has_stamina(cost: AbilityCost) -> bool:
	return _stats.has_stamina(cost.stamina)
