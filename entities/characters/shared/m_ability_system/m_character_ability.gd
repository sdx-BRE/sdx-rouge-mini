class_name MCharacterAbility extends RefCounted

var _stats: EntityStats
var _data: MCharacterAbilityData

func _init(
	stats: EntityStats,
	data: MCharacterAbilityData,
) -> void:
	_stats = stats
	_data = data

func get_input() -> StringName:
	return _data.input

func has_resources() -> bool:
	return _stats.has_mana(_data.cost.mana) and _stats.has_stamina(_data.cost.stamina)

func use_resources() -> void:
	_stats.use_mana(_data.cost.mana)
	_stats.use_stamina(_data.cost.stamina)
