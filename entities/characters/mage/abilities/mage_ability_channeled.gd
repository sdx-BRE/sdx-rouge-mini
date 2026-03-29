class_name MageAbilityChanneled extends MageAbilityBase

enum TickResult {
	Consume,
	Free,
}

func tick(delta: float) -> TickResult:
	push_error("[Error][MageAbilityChanneled]: tick() must be overwritten by child implementations, delta: ", delta)
	return TickResult.Free

func end() -> void:
	push_error("[Error][MageAbilityChanneled]: end() must be overwritten by child implementations")

func resolve_activation(handler: MageAbilityHandler, state: MageAbilityBase.TriggerState) -> void:
	handler.try_activate_channeled(self, state)
