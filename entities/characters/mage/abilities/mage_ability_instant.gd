class_name MageAbilityInstant extends MageAbilityBase

func trigger(state: MageAbilityBase.TriggerState) -> Result: 
	push_error("[Error][MageAbilityInstant]: trigger() must be overwritten by child implementations - state: ", state)
	return Result.Abort

enum Result {
	Trigger,
	Abort,
}
