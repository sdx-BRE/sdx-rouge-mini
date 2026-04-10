class_name NCharacterAbilityRegistry extends RefCounted

var _abilities: Dictionary[int, NCharacterAbility]
var _actions: Dictionary[StringName, int]

func add(id: int, ability: NCharacterAbility) -> void:
	_abilities[id] = ability
	_actions[ability.get_input()] = id

func get_ability(id: int) -> NCharacterAbility:
	return _abilities[id]

func get_actions() -> Dictionary[StringName, int]:
	return _actions
