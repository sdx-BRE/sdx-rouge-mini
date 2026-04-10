class_name NCharacterAbilityLoadout extends RefCounted

var _registry: NCharacterAbilityRegistry

func _init(
	registry: NCharacterAbilityRegistry
) -> void:
	_registry = registry

func grant_ability(data: NCharacterAbilityData) -> void:
	var ability := data.to_ability(null, null) # Todo: fixme
	_registry.add(data.id, ability)

