class_name CooldownManager extends RefCounted

# int = AbilityId, float = remaining cooldown
var _cooldowns: Dictionary[int, float] = {}

func tick(delta: float) -> void:
	for id in _cooldowns.keys():
		_cooldowns[id] -= delta
		if _cooldowns[id] <= 0:
			_cooldowns.erase(id)

func start_cooldown(ability: EnemyBaseAbility) -> void:
	_cooldowns[ability.id] = ability.cooldown

func has_cooldown(id: int) -> bool:
	return _cooldowns.has(id)

func has_ability_cooldown(ability: EnemyBaseAbility) -> bool:
	return _cooldowns.has(ability.id)

