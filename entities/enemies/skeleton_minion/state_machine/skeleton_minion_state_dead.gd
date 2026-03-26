class_name SkeletonMinionStateDead extends SkeletonMinionStateBase

func process(_delta: float) -> SkeletonMinionStateMachine.ChangeId:
	if _context.is_moving():
		_context.stop_instant()
	
	return SkeletonMinionStateMachine.ChangeId.None
