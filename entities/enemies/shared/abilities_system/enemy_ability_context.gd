class_name EnemyAbilityContext extends RefCounted

var _stats: EntityStats

func _init(stats: EntityStats) -> void:
	_stats = stats

func has_mana(cost: EnemyAbilityCost) -> bool:
	return _stats.has_mana(cost.mana)

func has_stamina(cost: EnemyAbilityCost) -> bool:
	return _stats.has_stamina(cost.stamina)
