class_name SkeletonMinionStateAlive extends RefCounted

var _state: SkeletonMinionStateBase
var _target_handler: SkeletonMinionStateMachineTargetHandler
var _data: SkeletonMinionStateData

var _states: Dictionary[SkeletonMinionStateMachine.ChangeId, SkeletonMinionStateBase]

func _init(
	state: SkeletonMinionStateBase,
	target_handler: SkeletonMinionStateMachineTargetHandler,
	data: SkeletonMinionStateData,
) -> void:
	_state = state
	_target_handler = target_handler
	_data = data

func add_state(id: SkeletonMinionStateMachine.ChangeId, state: SkeletonMinionStateBase) -> void:
	_states[id] = state

func process(delta: float) -> void:
	_data.attack_cooldown -= delta
	_check_aggro()
	
	var new_state := _state.process(delta)
	if new_state != SkeletonMinionStateMachine.ChangeId.None:
		_state = _states[new_state]
		_state.enter()

func _check_aggro() -> void:
	_target_handler.update_target()
	
	if _target_handler.has_target() and _state != _states[SkeletonMinionStateMachine.ChangeId.Aggro]:
		_state = _states[SkeletonMinionStateMachine.ChangeId.Aggro]
		_state.enter()
