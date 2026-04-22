class_name AbilityAimingPhase extends AbilityExecutionPhase

var _targeting: AbilityAimingHandler
var _context: AbilityAimingContext

func _init(
	exec: AbilityExecuter,
	ability: Ability,
	context: AbilityAimingContext,
) -> void:
	super(exec, ability)
	_context = context

func start() -> void:
	_targeting = _ability._data.targeting.get_strategy(_context)
	
	_targeting.target_aquired.connect(_on_target_aquired)
	_targeting.canceled.connect(_on_targeting_canceled)
	
	_targeting.setup(_ability._data.targeting)

func handle_input(event: InputEvent) -> bool:
	return _targeting.handle_input(event)

func tick(delta: float) -> void:
	_targeting.tick(delta)

func cancel() -> void:
	_exec.blackboard.is_cancelled = true
	_targeting.cancel()
	_exec.next_phase()

func _on_target_aquired(result: AbilityAimingResult) -> void:
	_exec.blackboard.aiming_result = result
	_exec.next_phase()

func _on_targeting_canceled() -> void:
	_exec.blackboard.is_cancelled = true
	_exec.next_phase()

func _to_string() -> String:
	return "AbilityExecutionAiming"
