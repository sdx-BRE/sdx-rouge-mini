class_name CharacterInstantAbility extends CharacterAbility

func trigger(state: CharacterAbilitySystem.TriggerState) -> Result:
	push_error("[Error][CharacterInstantAbility]: trigger() must be overwritten by child implementations - state: ", state)
	return Result.Abort

func _can_handle(handler: CharacterAbilityHandler) -> bool:
	return handler is InstantAbilityHandler

enum Result {
	Trigger,
	Abort,
}
