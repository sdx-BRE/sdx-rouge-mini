class_name CharacterAbility extends RefCounted

var _data: CharacterAbilityData

func _init(data: CharacterAbilityData) -> void:
	_data = data

func resolve_handler(handlers: Array[CharacterAbilityHandler]) -> CharacterAbilityHandler:
	for handler in handlers:
		if _can_handle(handler):
			return handler
	
	return null

func get_input() -> StringName:
	return _data.input

func _can_handle(handler: CharacterAbilityHandler) -> bool:
	push_error("[Error][CharacterAbilityHandler]: _can_handle() must be overwritten by child implementations, handler: ", handler)
	return false
