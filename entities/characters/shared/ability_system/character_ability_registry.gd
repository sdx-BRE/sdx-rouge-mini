class_name CharacterAbilityRegistry extends RefCounted

var _abilities: Dictionary[CharacterAbilityRegistry.Id, CharacterAbility]
var _actions: Dictionary[StringName, CharacterAbilityRegistry.Id]

func add(id: CharacterAbilityRegistry.Id, ability: CharacterAbility) -> void:
	_abilities[id] = ability
	_actions[ability.get_input()] = id

func get_ability(id: CharacterAbilityRegistry.Id) -> CharacterAbility:
	return _abilities[id]

func get_actions() -> Dictionary[StringName, CharacterAbilityRegistry.Id]:
	return _actions

# Todo: Move IDS out of ability system, use simple integers, so each character can use their own, locally valid ids
enum Id {
	Firepulse,
	Firebolt,
	Meteor,
	Dash,
	Jump,
	Sprint,
}
