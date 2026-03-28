class_name MageAbilityDash extends MageAbilityInstantAnimated

func trigger(state: MageAbilityBase.TriggerState) -> Result:
	if state != MageAbilityBase.TriggerState.PRESS or _controller.is_not_moving():
		return Result.Abort
	
	var forward_vector := _context.get_forward()
	forward_vector.y = 0
	forward_vector = forward_vector.normalized()
	
	_controller.push_dash_motion(forward_vector * _context.get_dash_power())
	_context.request_oneshot_animation(_anim.trigger)
	
	return Result.Trigger
