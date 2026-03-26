class_name SkeletonMinionStateAlive extends RefCounted

var _state: SkeletonMinionStateBase
var _context: SkeletonMinionStateContext

var _states: Dictionary[SkeletonMinionStateMachine.ChangeId, SkeletonMinionStateBase]

func _init(
	state: SkeletonMinionStateBase,
	context: SkeletonMinionStateContext,
) -> void:
	_state = state
	_context = context

func add_state(id: SkeletonMinionStateMachine.ChangeId, state: SkeletonMinionStateBase) -> void:
	_states[id] = state

func process(delta: float) -> void:
	_context.reduce_attack_cooldown(delta)
	_check_aggro()
	
	var new_state := _state.process(delta)
	if new_state != SkeletonMinionStateMachine.ChangeId.None:
		_state = _states[new_state]
		_state.enter()

func _check_aggro() -> void:
	_context.update_target()
	
	if _context.has_target() and _state != _states[SkeletonMinionStateMachine.ChangeId.Aggro]:
		_state = _states[SkeletonMinionStateMachine.ChangeId.Aggro]
		_state.enter()
