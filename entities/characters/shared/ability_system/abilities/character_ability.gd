class_name CharacterAbility extends RefCounted

func resolve_handler(handlers: Array[CharacterAbilityHandler]) -> CharacterAbilityHandler:
	for handler in handlers:
		if _can_handle(handler):
			return handler
	
	return null

func _can_handle(handler: CharacterAbilityHandler) -> bool:
	push_error("[Error][CharacterAbilityHandler]: _can_handle() must be overwritten by child implementations, handler: ", handler)
	return false
