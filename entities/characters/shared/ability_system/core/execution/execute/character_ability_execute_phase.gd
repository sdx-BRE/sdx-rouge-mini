class_name CharacterAbilityExecutePhase extends CharacterAbilityExecutionPhase

var _ability: CharacterAbility
var _context: CharacterAbilityExecuteContext

var _trigger_handler: CharacterAbilityExecuteTriggerHandler

func _init(
	exec: CharacterAbilityExecuter,
	ability: CharacterAbility,
	context: CharacterAbilityExecuteContext,
) -> void:
	super(exec)
	_ability = ability
	_context = context

func start() -> void:
	var effect_handler := _ability._data.effect.create_handler(_ability, _context)
	effect_handler.setup(_ability._data.effect)
	
	_trigger_handler = _ability._data.trigger.create_handler(_exec, effect_handler)
	_trigger_handler.setup(_ability._data.trigger)
	
	_trigger_handler.start()

func tick(delta: float) -> void:
	_trigger_handler.tick(delta)

func release() -> void:
	_trigger_handler.release()

func cancel() -> void:
	_trigger_handler.cancel()

func _to_string() -> String:
	return "CharacterAbilityExecutionExecute"
