class_name AbilityRegistry extends RefCounted

var _abilities: Dictionary[int, Ability]
var _actions: Dictionary[StringName, int]

func register(data: AbilityData, stats: EntityStats, cooldown_manager: CooldownManager) -> void:
	add(data.id, data.to_ability(stats, cooldown_manager))

func add(id: int, ability: Ability) -> void:
	_abilities[id] = ability
	_actions[ability.get_input()] = id

func get_ability(id: int) -> Ability:
	return _abilities[id]

func get_actions() -> Dictionary[StringName, int]:
	return _actions
