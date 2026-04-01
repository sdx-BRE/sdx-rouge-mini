class_name AbilityRegistry extends RefCounted

var _abilities: Dictionary[int, BaseAbility]

func add_ability(id: int, ability: BaseAbility) -> void:
	_abilities[id] = ability

func get_ability(id: int) -> BaseAbility:
	return _abilities[id]
