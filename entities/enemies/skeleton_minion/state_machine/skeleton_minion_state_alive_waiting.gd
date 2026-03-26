class_name SkeletonMinionStateAliveWaiting extends SkeletonMinionStateBase

var _wait_time: float = 0.0

func process(delta: float) -> SkeletonMinionStateMachine.ChangeId:
	_context.stop_moving()
	_wait_time -= delta
	
	if _wait_time <= 0:
		_context.next_patrol_point()
		return SkeletonMinionStateMachine.ChangeId.Walking
	
	return SkeletonMinionStateMachine.ChangeId.None

func enter() -> void:
	_wait_time = _context.get_wait_time()
