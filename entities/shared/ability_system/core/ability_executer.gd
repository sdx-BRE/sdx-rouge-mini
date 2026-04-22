class_name AbilityExecuter extends RefCounted

const PHASES: Array[Phase] = [
	Phase.Aiming,
	Phase.Setup,
	Phase.Execute,
	Phase.Recover,
]

enum Phase {
	Aiming,
	Setup,
	Execute,
	Recover,
}

var blackboard: AbilityExecutionBlackboard
var _factory: AbilityExecutionFactory

var _phase: AbilityExecutionPhase
var _ability: Ability

var _phase_idx: int = 0

func _init(
	p_blackboard: AbilityExecutionBlackboard,
	factory: AbilityExecutionFactory,
) -> void:
	blackboard = p_blackboard
	_factory = factory

func start(
	ability: Ability,
) -> void:
	if _phase != null:
		_phase.cancel()
	
	blackboard.cleanup()
	_ability = ability
	_phase_idx = 0
	_phase = _factory.create(Phase.Aiming, ability, self)
	
	_phase.start()

func release() -> void:
	if _is_active():
		blackboard.is_released = true
		_phase.release()

func handle_input(event: InputEvent) -> bool:
	if not _is_active():
		return false
	
	return _phase.handle_input(event)

func tick(delta: float) -> void:
	if not _is_active():
		return
	
	_dbg_tick(delta)
	_phase.tick(delta)

func handle_animation_event() -> void:
	if not _is_active():
		return
	
	_phase.animation_trigger()

func notify_hit_event(target: Node3D) -> void:
	if not _is_active():
		return
	
	_phase.hit_event(target)

func next_phase() -> void:
	if not _is_active():
		return
	
	var next_idx := _phase_idx + 1
	
	if next_idx >= PHASES.size():
		finish()
	else:
		_dbg_next_phase()
		_phase_idx = next_idx
		_phase = _factory.create(PHASES[_phase_idx], _ability, self)
		_phase.start()

func finish() -> void:
	_cleanup_member()

func abort() -> void:
	_cleanup_member()

func _cleanup_member() -> void:
	_phase = null
	_ability = null
	_phase_idx = 0
	blackboard.cleanup()

func _is_active() -> bool:
	return _ability != null and _phase != null

func _dbg_next_phase() -> void:
	if not _ability._data.debug:
		return
	
	_dbg_info("Next phase")

var _dbg_tick_timer := 2.0
func _dbg_tick(delta: float) -> void:
	if not _ability._data.debug:
		return
	
	_dbg_tick_timer -= delta
	if _dbg_tick_timer > 0.0:
		return
	
	_dbg_tick_timer = 2.0
	_dbg_info("Tick", true, false)

func _dbg_info(message: String, include_phase: bool = true, include_previous_phase: bool = true) -> void:
	if not _ability._data.debug:
		return
	
	var separator := "\n\t"
	var phase_keys := Phase.keys()
	
	var info := [
		"Ability: '%s'" % _ability._data.id,
	]
	if include_phase and _arr_key_exists(_phase_idx, phase_keys):
		info.append("Phase: '%s'" % phase_keys[_phase_idx])
	
	if include_previous_phase and _arr_key_exists(_phase_idx - 1, phase_keys):
		info.append("Previous phase: '%s'" % phase_keys[_phase_idx - 1])
	
	var msg := "[AbilityExecuter]: %s%s%s" % [message, separator, separator.join(info)]
	DbgHelper.tprint(msg)

func _arr_key_exists(key: int, arr: Array) -> bool:
	return key >= 0 and key < arr.size()
