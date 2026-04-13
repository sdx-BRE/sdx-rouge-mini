class_name CharacterAbilityExecutionSetup extends CharacterAbilityExecutionBase

var _data: CharacterAbilityData
var _context: CharacterAbilityExecutionSetupContext

var _windup_handler: CharacterAbilityExecutionSetupWindupHandler

func _init(
	exec: CharacterAbilityExecution,
	data: CharacterAbilityData,
	context: CharacterAbilityExecutionSetupContext,
) -> void:
	super(exec)
	_data = data
	_context = context

func start() -> void:
	_windup_handler = _data.windup.create_handler(_context)
	_windup_handler.setup(_data.windup)
	
	_windup_handler.visual_ready.connect(_exec.next_phase)
	_windup_handler.start()

func cancel() -> void:
	_windup_handler.cancel()
	_exec.abort()

func tick(_delta: float) -> void:
	_windup_handler.tick()

func animation_trigger() -> void:
	_windup_handler.trigger()

func _to_string() -> String:
	return "CharacterAbilityExecutionSetup"
