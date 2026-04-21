class_name AbilityRegistry extends RefCounted

var _abilities: Dictionary[StringName, Ability]
var _actions: Dictionary[StringName, StringName]

func register(data: AbilityData, stats: EntityStats, cooldown_manager: CooldownManager) -> void:
	add(data.id, data.to_ability(stats, cooldown_manager))

func add(id: StringName, ability: Ability) -> void:
	_abilities[id] = ability
	_actions[ability.get_input()] = id

func get_ability(id: StringName) -> Ability:
	return _abilities.get(id)

func get_actions() -> Dictionary[StringName, StringName]:
	return _actions

func get_ability_input_map() -> Dictionary[StringName, StringName]:
	var mapping: Dictionary[StringName, StringName] = {}
	for input_action in _actions:
		var id = _actions[input_action]
		mapping[id] = input_action
	
	return mapping
