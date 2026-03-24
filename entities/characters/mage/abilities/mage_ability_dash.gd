class_name MageAbilityDash extends MageAbilityInstant

func trigger() -> void:
	if _controller.is_not_moving() or not _context.has_stamina():
		return
	
	var forward_vector := _context.get_forward()
	forward_vector.y = 0
	forward_vector = forward_vector.normalized()
	
	_controller.push_dash_motion(forward_vector * _context.get_dash_power())
	_context.use_stamina(10)
