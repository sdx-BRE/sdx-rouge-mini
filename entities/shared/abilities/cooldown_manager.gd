class_name CooldownManager extends RefCounted

signal cooldown_started(action: StringName, cooldown: float)

# int = AbilityId, float = remaining cooldown
var _cooldowns: Dictionary[int, float] = {}

func tick(delta: float) -> void:
	for id in _cooldowns.keys():
		_cooldowns[id] -= delta
		if _cooldowns[id] <= 0:
			_cooldowns.erase(id)

func start_cooldown(id: int, cooldown: float) -> void:
	_cooldowns[id] = cooldown

func start_enemy_cooldown(ability: EnemyBaseAbility) -> void:
	start_cooldown(ability.id, ability.cooldown)

func start_character_cooldown(ability: CharacterAbilityData) -> void:
	start_cooldown(ability.id, ability.cooldown)
	cooldown_started.emit(ability.input, ability.cooldown)

func has_cooldown(id: int) -> bool:
	return _cooldowns.has(id)

func has_enemy_cooldown(ability: EnemyBaseAbility) -> bool:
	return _cooldowns.has(ability.id)

func has_character_cooldown(ability: CharacterAbilityData) -> bool:
	return _cooldowns.has(ability.id)
