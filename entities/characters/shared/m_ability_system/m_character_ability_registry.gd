class_name MCharacterAbilityRegistry extends RefCounted

var _abilities: Dictionary[int, MCharacterAbility]
var _actions: Dictionary[StringName, int]

func register(data: MCharacterAbilityData, stats: EntityStats, cooldown_manager: CooldownManager) -> void:
	add(data.id, data.to_ability(stats, cooldown_manager))

func add(id: int, ability: MCharacterAbility) -> void:
	_abilities[id] = ability
	_actions[ability.get_input()] = id

func get_ability(id: int) -> MCharacterAbility:
	return _abilities[id]

func get_actions() -> Dictionary[StringName, int]:
	return _actions
