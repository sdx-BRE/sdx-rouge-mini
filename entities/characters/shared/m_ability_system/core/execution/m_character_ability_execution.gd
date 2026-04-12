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
	_ability = ability
	
	if _phase != null:
		_phase.cancel()
	
	_phase_idx = 0
	_phase = _factory.create(Phase.Aiming, ability._data, self)
	
	_phase.start()

func release() -> void:
	if _phase != null:
		_phase.release()

func handle_input(event: InputEvent) -> bool:
	if _phase == null:
		return false
	
	return _phase.handle_input(event)

func tick(delta: float) -> void:
	if _phase == null:
		return
	
	_phase.tick(delta)

func handle_animation_event() -> void:
	_phase.animation_trigger()

func next_phase() -> void:
	var next_idx := _phase_idx + 1
	if next_idx > PHASES.size():
		abort()
	else:
		_phase_idx = next_idx
		_phase = _factory.create(PHASES[_phase_idx], _ability._data, self)
		_phase.start()

func finish() -> void:
	_cleanup_member()

func abort() -> void:
	_cleanup_member()

func _cleanup_member() -> void:
	_phase = null
	_ability = null
	_phase_idx = 0
