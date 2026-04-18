class_name AbilitySetupPhase extends AbilityExecutionPhase

var _context: AbilitySetupContext

var _windup_handler: AbilitySetupWindupHandler

func _init(
	exec: AbilityExecuter,
	ability: Ability,
	context: AbilitySetupContext,
) -> void:
	super(exec, ability)
	_context = context

func start() -> void:
	_windup_handler = _ability._data.windup.create_setup_handler(_context)
	_windup_handler.setup(_ability._data.windup)
	
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
	return "AbilityExecutionSetup"
