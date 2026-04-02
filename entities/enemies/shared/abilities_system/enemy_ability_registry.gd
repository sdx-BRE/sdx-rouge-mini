class_name EnemyAbilityRegistry extends RefCounted

var _abilities: Dictionary[int, EnemyBaseAbility]

func add_ability(id: int, ability: EnemyBaseAbility) -> void:
	ability.id = id
	_abilities[id] = ability

func get_ability(id: int) -> EnemyBaseAbility:
	return _abilities[id]
