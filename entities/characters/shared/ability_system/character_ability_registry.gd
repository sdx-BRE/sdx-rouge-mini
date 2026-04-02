class_name CharacterAbilityRegistry extends RefCounted

var _abilities: Dictionary[CharacterAbilityRegistry.Id, CharacterAbilityInfo]
var _actions: Dictionary[StringName, CharacterAbilityRegistry.Id]

func add(id: CharacterAbilityRegistry.Id, ability: CharacterAbilityInfo) -> void:
	_abilities[id] = ability

func get_ability(id: CharacterAbilityRegistry.Id) -> CharacterAbility:
	return _abilities[id].ability

func get_actions() -> Dictionary[StringName, CharacterAbilityRegistry.Id]:
	return _actions

func build_actions_dict():
	var result: Dictionary[StringName, CharacterAbilityRegistry.Id] = {}
	for idx in _abilities:
		for action in _abilities[idx].actions:
			result[action] = idx
	_actions = result

# Todo: Move IDS out of ability system, use simple integers, so each character can use their own, locally valid ids
enum Id {
	Firepulse,
	Firebolt,
	Meteor,
	Dash,
	Jump,
	Sprint,
}
