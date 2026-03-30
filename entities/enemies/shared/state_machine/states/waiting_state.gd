class_name WaitingState extends StateBase

var _wait_time: float = 0.0

func process(delta: float) -> int:
	_ctx.stop_moving()
	_wait_time -= delta
	
	if _wait_time <= 0:
		_ctx.next_patrol_point()
		return StateTransition.WALKING
	
	return StateTransition.NONE

func enter() -> void:
	_wait_time = _ctx.get_wait_time()
