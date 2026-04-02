class_name CharacterInstantAbility extends CharacterAbility

func trigger(state: CharacterAbilitySystem.TriggerState) -> Result:
	push_error("[Error][CharacterInstantAbility]: trigger() must be overwritten by child implementations - state: ", state)
	return Result.Abort

enum Result {
	Trigger,
	Abort,
}
