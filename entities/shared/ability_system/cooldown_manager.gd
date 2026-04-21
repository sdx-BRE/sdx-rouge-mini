class_name CooldownManager extends RefCounted

signal cooldown_started(action: StringName, cooldown: float)

# StringName = AbilityId, float = remaining cooldown
var _cooldowns: Dictionary[StringName, float] = {}

func tick(delta: float) -> void:
	for id in _cooldowns.keys():
		_cooldowns[id] -= delta
		if _cooldowns[id] <= 0:
			_cooldowns.erase(id)

func start_cooldown(id: StringName, cooldown: float) -> void:
	_cooldowns[id] = cooldown
	cooldown_started.emit(id, cooldown)

func has_cooldown(id: StringName) -> bool:
	return _cooldowns.has(id)
