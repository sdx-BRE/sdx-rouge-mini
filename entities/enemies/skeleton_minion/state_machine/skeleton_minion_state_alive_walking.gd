class_name SkeletonMinionStateAliveWalking extends SkeletonMinionStateBase

func process(delta: float) -> SkeletonMinionStateMachine.ChangeId:
	if _controller.is_navigation_finished():
		return SkeletonMinionStateMachine.ChangeId.Waiting
	
	_controller.navigate_to_target(_data.walking_speed, delta)
	return SkeletonMinionStateMachine.ChangeId.None
