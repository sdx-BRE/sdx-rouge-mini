class_name CharacterAbility extends RefCounted

var _controller: MageController
var _context: CharacterAbilityContext
var _cost: AbilityCost

func _init(
	controller: MageController, 
	context: CharacterAbilityContext, 
	cost: AbilityCost,
) -> void:
	_controller = controller
	_context = context
	_cost = cost

func has_resources() -> bool:
	return _context.has_resources(_cost)

func use_resources() -> void:
	_context.use_resources(_cost)

func resolve_handler(handlers: Array[CharacterAbilityHandler]) -> CharacterAbilityHandler:
	for handler in handlers:
		if _can_handle(handler):
			return handler
	
	return null

func _can_handle(handler: CharacterAbilityHandler) -> bool:
	push_error("[Error][CharacterAbilityHandler]: _can_handle() must be overwritten by child implementations, handler: ", handler)
	return false
