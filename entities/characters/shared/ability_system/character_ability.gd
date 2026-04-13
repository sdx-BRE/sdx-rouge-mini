class_name CharacterAbility extends RefCounted

var _stats: EntityStats
var _data: CharacterAbilityData
var _cooldown_manager: CooldownManager

func _init(
	stats: EntityStats,
	data: CharacterAbilityData,
	cooldown_manager: CooldownManager,
) -> void:
	_stats = stats
	_data = data
	_cooldown_manager = cooldown_manager

func get_input() -> StringName:
	return _data.input

func check_resources() -> bool:
	match _data.cost.type:
		AbilityCost.Type.Instant:
			return _stats.has_mana(_data.cost.mana) and _stats.has_stamina(_data.cost.stamina)
		AbilityCost.Type.Tick:
			var min_buffer := 0.1
			return _stats.has_mana(_data.cost.mana * min_buffer) and _stats.has_stamina(_data.cost.stamina * min_buffer)
		AbilityCost.Type.External:
			return true
	
	return false

func has_resources() -> bool:
	return _stats.has_mana(_data.cost.mana) and _stats.has_stamina(_data.cost.stamina)

func use_resources() -> void:
	_stats.use_mana(_data.cost.mana)
	_stats.use_stamina(_data.cost.stamina)

func use_resources_delta(delta: float) -> void:
	_stats.use_mana(_data.cost.mana * delta)
	_stats.use_stamina(_data.cost.stamina * delta)

func start_cooldown() -> void:
	_cooldown_manager.start_character_cooldown(self._data)

func has_cooldown() -> void:
	_cooldown_manager.has_character_cooldown(self._data)
