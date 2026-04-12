class_name MCharacterAbilityExecutionSetup extends MCharacterAbilityExecutionBase

var _data: MCharacterAbilityData
var _context: MCharacterAbilityExecutionSetupContext

var _windup_handler: MCharacterAbilityExecutionSetupWindupHandler

func _init(
	exec: MCharacterAbilityExecution,
	data: MCharacterAbilityData,
	context: MCharacterAbilityExecutionSetupContext,
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
	pass

func tick(_delta: float) -> void:
	_windup_handler.tick()

func animation_trigger() -> void:
	_windup_handler.trigger()
