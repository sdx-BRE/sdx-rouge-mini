class_name CharacterAbilityRecoverPhase extends CharacterAbilityExecutionPhase

var _context: CharacterAbilityRecoverContext

var _windup_handler: CharacterAbilityRecoverWindupHandler

func _init(
	exec: CharacterAbilityExecuter,
	ability: CharacterAbility,
	context: CharacterAbilityRecoverContext,
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
