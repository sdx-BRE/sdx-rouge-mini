class_name CharacterJumpAbility extends CharacterInstantAbility

# Todo: implement proper support for multi jumps
# Todo: use apex threshold and gravity multiplier on consecutive jumps,
# Todo: e.g. set multiplier to 0.8 on second and 0.65 on third jump

# Todo: adjust kinetic, implement jump buffer, so pressing jump right before landing triggers next jump

# Todo: when prematurely release jump button, reduce jump height
func trigger(state: CharacterAbilitySystem.TriggerState) -> Result:
	if state == CharacterAbilitySystem.TriggerState.Press:
		_context.buffer_jump()
	
	return Result.NoCost
