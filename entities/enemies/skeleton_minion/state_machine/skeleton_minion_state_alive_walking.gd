class_name SkeletonMinionStateAliveWalking extends SkeletonMinionStateBase

func process(delta: float) -> SkeletonMinionStateMachine.ChangeId:
	if _context.is_navigation_finished():
		return SkeletonMinionStateMachine.ChangeId.Waiting
	
	_context.walk_to_target(delta)
	return SkeletonMinionStateMachine.ChangeId.None
