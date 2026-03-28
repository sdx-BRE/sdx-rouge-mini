class_name MageAbilityInstant extends MageAbilityBase

func resolve_activation(handler: MageAbilityHandler, state: MageAbilityBase.TriggerState) -> void:
	handler.try_activate_instant(self, state)

func trigger(state: MageAbilityBase.TriggerState) -> Result: 
	push_error("[Error][MageAbilityInstant]: trigger() must be overwritten by child implementations - state: ", state)
	return Result.Abort

enum Result {
	Trigger,
	Abort,
}
