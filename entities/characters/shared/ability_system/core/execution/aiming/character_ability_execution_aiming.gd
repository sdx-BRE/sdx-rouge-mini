class_name CharacterAbilityExecutionAiming extends CharacterAbilityExecutionBase

var _targeting: CharacterAbilityExecutionAimingBase
var _data: CharacterAbilityData
var _context: CharacterAbilityExecutionAimingContext

func _init(
	exec: CharacterAbilityExecution,
	data: CharacterAbilityData,
	context: CharacterAbilityExecutionAimingContext,
) -> void:
	super(exec)
	_data = data
	_context = context

func start() -> void:
	_targeting = _data.targeting.get_strategy(_context)
	
	_targeting.target_aquired.connect(_on_target_aquired)
	_targeting.canceled.connect(_on_targeting_canceled)
	
	_targeting.setup(_data.targeting)

func handle_input(event: InputEvent) -> bool:
	return _targeting.handle_input(event)

func tick(delta: float) -> void:
	_targeting.tick(delta)

func cancel() -> void:
	_targeting.cancel()

func _on_target_aquired(result: CharacterAbilityAimingResult) -> void:
	_exec.blackboard.aiming_result = result
	_exec.next_phase()

func _on_targeting_canceled() -> void:
	_exec.abort()

func _to_string() -> String:
	return "CharacterAbilityExecutionAiming"
