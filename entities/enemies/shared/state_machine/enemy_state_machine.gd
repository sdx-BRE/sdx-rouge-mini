class_name EnemyStateMachine extends RefCounted

var _states: Dictionary[int, StateBase]
var _transition_rules: Array[StateTransitionRule]

var _stack: Array[StateBase]

func _init(
	initial_state: StateBase,
	states: Dictionary[int, StateBase],
	transition_rules: Array[StateTransitionRule],
) -> void:
	_states = states
	_transition_rules = transition_rules
	_stack.append(initial_state)

func process(delta: float) -> void:
	_check_rules()
	_handle_state(delta)

func _check_rules() -> void:
	for rule in _transition_rules:
		if rule.condition.call() and not _is_current_state(rule.transition_id):
			_push_stack(rule.transition_id)
			return

func _handle_state(delta: float) -> void:
	var transition_id := _current_state().process(delta)
	match transition_id:
		StateTransition.NONE: return
		StateTransition.POP: _pop_stack()
		_: _transition_to(transition_id)

func _transition_to(transition_id: int) -> void:
	var state = _states.get(transition_id)
	if state == null:
		push_error("[ERROR][EnemyStateMachine._transition_to()] - state not found, transition id: ", transition_id)
		return
	
	var previous = _stack.pop_back()
	previous.exit()
	
	_stack.append(state)
	state.enter()

func _pop_stack() -> void:
	_stack.back().exit()
	_stack.pop_back()

func _push_stack(transition_id: int) -> void:
	var state = _states.get(transition_id)
	if state == null:
		push_error("[ERROR][EnemyStateMachine._push()] - state not found, transition id: ", transition_id)
	
	_stack.append(state)
	state.enter()

func _current_state() -> StateBase:
	return _stack.back()

func _is_current_state(transition_id: int) -> bool:
	var state = _states.get(transition_id)
	if state == null:
		return false
	
	return _stack.back() == state
