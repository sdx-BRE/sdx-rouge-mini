class_name MageAbilityJump extends MageAbilityInstantAnimated

func trigger() -> Result:
	_controller.jump()
	
	return Result.Trigger
