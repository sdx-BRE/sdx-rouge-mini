class_name CharacterInstantAbility extends CharacterAbility

var _context: InstantContext

func _init(data: CharacterAbilityData, stats: EntityStats, context: InstantContext) -> void:
	super(data, stats)
	_context = context

func trigger(state: CharacterAbilitySystem.TriggerState) -> Result:
	push_error("[Error][CharacterInstantAbility]: trigger() must be overwritten by child implementations - state: ", state)
	return Result.NoCost

func _can_handle(handler: CharacterAbilityHandler) -> bool:
	return handler is InstantAbilityHandler

enum Result {
	Consume,
	NoCost,
}
