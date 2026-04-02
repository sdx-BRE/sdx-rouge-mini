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
