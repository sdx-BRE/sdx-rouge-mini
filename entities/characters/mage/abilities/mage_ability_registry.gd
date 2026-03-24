class_name MageAbilityRegistry extends RefCounted

var _abilities: Dictionary[MageAbilityId.Id, MageAbilityInfo]
var _actions: Dictionary[StringName, MageAbilityId.Id]

func add(id: MageAbilityId.Id, ability: MageAbilityInfo) -> void:
	_abilities[id] = ability
	_build_actions_dict()

func get_ability(id: MageAbilityId.Id) -> MageAbilityBase:
	return _abilities[id].ability

func get_actions() -> Dictionary[StringName, MageAbilityId.Id]:
	return _actions

func _build_actions_dict():
	var result: Dictionary[StringName, MageAbilityId.Id] = {}
	for idx in _abilities:
		for action in _abilities[idx].actions:
			result[action] = idx
	_actions = result
