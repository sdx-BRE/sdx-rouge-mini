class_name MageAbilityJump extends MageAbilityInstant

func trigger() -> Result:
	if not _controller.is_on_floor():
		return Result.Abort
	
	_controller.jump()
	
	return Result.Trigger
