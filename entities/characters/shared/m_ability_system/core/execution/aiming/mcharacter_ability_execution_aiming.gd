class_name McharacterAbilityExecutionAiming extends MCharacterAbilityExecutionBase

var _targeting: McharacterAbilityExecutionAimingBase
var _data: MCharacterAbilityTargeting
var _context: McharacterAbilityExecutionAimingContext

func _init(
	exec: MCharacterAbilityExecution, 
	data: MCharacterAbilityTargeting,
	context: McharacterAbilityExecutionAimingContext,
) -> void:
	super(exec)
	_data = data
	_context = context

func start() -> void:
	_targeting = _data.get_strategy(_context)
	_targeting.setup(_data)
	
	_targeting.target_aquired.connect(_on_target_aquired)
	_targeting.canceled.connect(_on_targeting_canceled)

func handle_input(event: InputEvent) -> bool:
	return _targeting.handle_input(event)

func tick(delta: float) -> void:
	_targeting.tick(delta)

func cancel() -> void:
	_targeting.cancel()

func _on_target_aquired(result: McharacterAbilityAimingResult) -> void:
	# todo: write to blackboard
	_exec.next_phase()

func _on_targeting_canceled() -> void:
	_exec.abort()
