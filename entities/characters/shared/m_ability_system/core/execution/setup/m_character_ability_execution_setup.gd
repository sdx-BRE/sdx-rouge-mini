class_name MCharacterAbilityExecutionSetup extends MCharacterAbilityExecutionBase

var _data: MCharacterAbilityData
var _context: MCharacterAbilityExecutionSetupContext

var _trigger_handler: MCharacterAbilityExecutionSetupTriggerHandler
var _windup_handler: MCharacterAbilityExecutionSetupWindupHandler

var _is_trigger_ready: bool = false
var _is_visual_ready: bool = false

func _init(
	exec: MCharacterAbilityExecution,
	data: MCharacterAbilityData,
	context: MCharacterAbilityExecutionSetupContext,
) -> void:
	super(exec)
	_data = data
	_context = context

func start() -> void:
	_trigger_handler = _data.trigger.create_handler(_context)
	_windup_handler = _data.windup.create_handler(_context)
	
	_trigger_handler.setup(_data.trigger)
	_windup_handler.setup(_data.windup)
	
	_trigger_handler.execution_requested.connect(_on_execution_requested)
	_windup_handler.visual_ready.connect(_on_visual_ready)
	
	_trigger_handler.start()
	_windup_handler.start()

func release() -> void:
	if _trigger_handler != null:
		_trigger_handler.release()

func cancel() -> void:
	pass

func tick(delta: float) -> void:
	_trigger_handler.tick(delta)
	_windup_handler.tick()

func animation_trigger() -> void:
	_windup_handler.trigger()

func _check_transition() -> void:
	if _is_trigger_ready and _is_visual_ready:
		_exec.next_phase()

func _on_execution_requested() -> void:
	_is_trigger_ready = true
	_check_transition()

func _on_visual_ready() -> void:
	_is_visual_ready = true
	_check_transition()
