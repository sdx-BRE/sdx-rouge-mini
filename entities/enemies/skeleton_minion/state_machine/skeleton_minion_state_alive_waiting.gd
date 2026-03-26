class_name SkeletonMinionStateAliveWaiting extends SkeletonMinionStateBase

var _wait_time: float = 0.0

func process(delta: float) -> SkeletonMinionStateMachine.ChangeId:
	_controller.apply_friction_if_moving(_data.walking_speed)
	_wait_time -= delta
	
	if _wait_time <= 0:
		_controller.next_patrol_point()
		return SkeletonMinionStateMachine.ChangeId.Walking
	
	return SkeletonMinionStateMachine.ChangeId.None

func enter() -> void:
	_wait_time = _data.wait_time
