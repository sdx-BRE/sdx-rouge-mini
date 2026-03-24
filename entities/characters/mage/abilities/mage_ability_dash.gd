class_name MageAbilityDash extends MageAbilityInstant

var _anim: MageAbilityAnimation

func _init(
	controller: MageController,
	context: MageAbilityContext,
	cost: MageAbilityCost,
	anim: MageAbilityAnimation,
) -> void:
	super(controller, context, cost)
	_anim = anim


func trigger() -> Result:
	if _controller.is_not_moving(): return Result.Abort
	
	var forward_vector := _context.get_forward()
	forward_vector.y = 0
	forward_vector = forward_vector.normalized()
	
	_controller.push_dash_motion(forward_vector * _context.get_dash_power())
	_context.request_oneshot_animation(_anim.oneshot_prop)
	
	return Result.Trigger
