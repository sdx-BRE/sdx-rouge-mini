class_name CharacterAbilityRecoverPhase extends CharacterAbilityExecutionPhase

var _data: CharacterAbilityData
var _context: CharacterAbilityRecoverContext

var _windup_handler: CharacterAbilityRecoverWindupHandler

func _init(
	exec: CharacterAbilityExecuter,
	data: CharacterAbilityData,
	context: CharacterAbilityRecoverContext,
) -> void:
	super(exec)
	_data = data
	_context = context

func start() -> void:
	_windup_handler = _data.windup.create_recover_handler(_context)
	_windup_handler.recover()
	_exec.finish()
