class_name AbilityRecoverPhase extends AbilityExecutionPhase

var _context: AbilityRecoverContext

var _windup_handler: AbilityRecoverWindupHandler

func _init(
	exec: AbilityExecuter,
	ability: Ability,
	context: AbilityRecoverContext,
) -> void:
	super(exec, ability)
	_context = context

func start() -> void:
	_windup_handler = _ability._data.windup.create_recover_handler(_context)
	_windup_handler.setup(_ability._data.windup)
	
	_windup_handler.recover()
	_exec.finish()

func cancel() -> void:
	_windup_handler.cancel()
