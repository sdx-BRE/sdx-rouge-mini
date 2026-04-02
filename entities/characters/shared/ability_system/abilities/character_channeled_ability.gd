class_name CharacterChanneledAbility extends CharacterAbility

enum TickResult {
	Consume,
	Free,
}

func tick(delta: float) -> TickResult:
	push_error("[Error][MageAbilityChanneled]: tick() must be overwritten by child implementations, delta: ", delta)
	return TickResult.Free

func end() -> void:
	push_error("[Error][MageAbilityChanneled]: end() must be overwritten by child implementations")
