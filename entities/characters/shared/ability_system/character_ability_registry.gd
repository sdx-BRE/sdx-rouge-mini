class_name CharacterAbilityRegistry extends RefCounted

var _abilities: Dictionary[MageAbilityId.Id, CharacterAbilityInfo]
var _actions: Dictionary[StringName, CharacterAbilityRegistry.Id]

func add(id: CharacterAbilityRegistry.Id, ability: CharacterAbilityInfo) -> void:
	_abilities[id] = ability

func get_ability(id: CharacterAbilityRegistry.Id) -> CharacterAbility:
	return _abilities[id].ability

func get_actions() -> Dictionary[StringName, CharacterAbilityRegistry.Id]:
	return _actions

enum Id {
	
}
