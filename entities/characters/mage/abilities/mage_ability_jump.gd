class_name MageAbilityJump extends MageAbilityInstant

func trigger() -> Result:
	DbgHelper.tprint("received jump... just buffer it")
	
	_controller.buffer_jump()
	return Result.Abort
	
	# new logic
	
	# old
	#if not _controller.is_on_floor():
	#	return Result.Abort
	#_controller.jump()
	
	# Todo: implement proper support for multi jumps
	# use apex threshold and gravity multiplier on consecutive jumps,
	# e.g. set multiplier to 0.8 on second and 0.65 on third jump
	
	# adjust kinetic, implement jump buffer, so pressing jump right before landing triggers next jump
	
	# when prematurely release jump button, reduce jump height
	
	return Result.Trigger
