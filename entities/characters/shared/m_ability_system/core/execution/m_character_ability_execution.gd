class_name MCharacterAbilityExecution extends RefCounted

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

var blackboard: MCharacterAbilityExecutionBlackboard
var _factory: MCharacterAbilityExecutionFactory

var _phase: MCharacterAbilityExecutionBase
var _ability: MCharacterAbility

var _phase_idx: int = 0

func _init(
	p_blackboard: MCharacterAbilityExecutionBlackboard,
	factory: MCharacterAbilityExecutionFactory,
) -> void:
	blackboard = p_blackboard
	_factory = factory

func start(
	ability: MCharacterAbility,
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
		_phase.release()

func handle_input(event: InputEvent) -> bool:
	if not _is_active():
		return false
	
	return _phase.handle_input(event)

func tick(delta: float) -> void:
	if not _is_active():
		return
	
	_phase.tick(delta)

func handle_animation_event() -> void:
	if not _is_active():
		return
	
	_phase.animation_trigger()

func next_phase() -> void:
	if not _is_active():
		return
	
	var next_idx := _phase_idx + 1
	
	if next_idx >= PHASES.size():
		finish()
	else:
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
