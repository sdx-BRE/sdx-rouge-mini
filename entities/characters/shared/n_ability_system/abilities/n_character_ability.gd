class_name NCharacterAbility extends RefCounted

var _data: NCharacterAbilityData
var _stats: EntityStats

func _init(data: NCharacterAbilityData, stats: EntityStats) -> void:
	_data = data
	_stats = stats

func has_resources() -> bool:
	return _stats.has_mana(_data.cost.mana) and _stats.has_stamina(_data.cost.stamina)

func use_resources() -> void:
	_stats.use_mana(_data.cost.mana)
	_stats.use_stamina(_data.cost.stamina)

func get_input() -> StringName:
	return _data.input

func get_handler() -> NCharacterAbilityHandler.Execution:
	return _data.get_handler()

func get_id() -> int:
	return _data.id
