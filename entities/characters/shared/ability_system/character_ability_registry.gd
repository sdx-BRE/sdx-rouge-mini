class_name CharacterAbilityRegistry extends RefCounted

var _abilities: Dictionary[int, CharacterAbility]
var _actions: Dictionary[StringName, int]

func register(data: CharacterAbilityData, stats: EntityStats, cooldown_manager: CooldownManager) -> void:
	add(data.id, data.to_ability(stats, cooldown_manager))

func add(id: int, ability: CharacterAbility) -> void:
	_abilities[id] = ability
	_actions[ability.get_input()] = id

func get_ability(id: int) -> CharacterAbility:
	return _abilities[id]

func get_actions() -> Dictionary[StringName, int]:
	return _actions
