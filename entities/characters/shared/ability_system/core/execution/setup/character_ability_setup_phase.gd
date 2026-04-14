class_name CharacterAbilitySetupPhase extends CharacterAbilityExecutionPhase

var _data: CharacterAbilityData
var _context: CharacterAbilitySetupContext

var _windup_handler: CharacterAbilitySetupWindupHandler

func _init(
	exec: CharacterAbilityExecuter,
	data: CharacterAbilityData,
	context: CharacterAbilitySetupContext,
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
