class_name CharacterAbility extends RefCounted

var _data: CharacterAbilityData
var _stats: EntityStats

func _init(data: CharacterAbilityData, stats: EntityStats) -> void:
	_data = data
	_stats = stats

func resolve_handler(handlers: Array[CharacterAbilityHandler]) -> CharacterAbilityHandler:
	for handler in handlers:
		if _can_handle(handler):
			return handler
	
	return null

func has_resources() -> bool:
	return _stats.has_mana(_data.cost.mana) and _stats.has_stamina(_data.cost.stamina)

func use_resources() -> void:
	_stats.use_mana(_data.cost.mana)
	_stats.use_stamina(_data.cost.stamina)

func get_input() -> StringName:
	return _data.input

func _can_handle(handler: CharacterAbilityHandler) -> bool:
	push_error("[Error][CharacterAbilityHandler]: _can_handle() must be overwritten by child implementations, handler: ", handler)
	return false
