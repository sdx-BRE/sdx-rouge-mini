class_name CharacterInstantAbility extends CharacterAbility

var _context: InstantContext

func _init(data: CharacterAbilityData, context: InstantContext) -> void:
	super(data)
	_context = context

func trigger(state: CharacterAbilitySystem.TriggerState) -> Result:
	push_error("[Error][CharacterInstantAbility]: trigger() must be overwritten by child implementations - state: ", state)
	return Result.Abort

func has_resources() -> bool:
	return _context.has_resources(_data.cost)

func use_resources() -> void:
	_context.use_resources(_data.cost)

func _can_handle(handler: CharacterAbilityHandler) -> bool:
	return handler is InstantAbilityHandler

enum Result {
	Trigger,
	Abort,
}
