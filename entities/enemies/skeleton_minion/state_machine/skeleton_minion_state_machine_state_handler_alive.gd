class_name SkeletonMinionStateMachineStateHandlerAlive extends SkeletonMinionStateMachineStateHandlerBase

var _state: SkeletonMinionStateAlive

func _init(state: SkeletonMinionStateAlive) -> void:
	_state = state

func handle(delta: float) -> void:
	_state.process(delta)
