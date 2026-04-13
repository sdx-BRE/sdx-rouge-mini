class_name CharacterAbilityExecutionExecute extends CharacterAbilityExecutionBase

var _ability: CharacterAbility
var _context: CharacterAbilityExecutionExecuteContext

var _effect_handler: CharacterAbilityExecutionExecuteEffectHandler

func _init(
	exec: CharacterAbilityExecution,
	ability: CharacterAbility,
	context: CharacterAbilityExecutionExecuteContext,
) -> void:
	super(exec)
	_ability = ability
	_context = context

func start() -> void:
	_effect_handler = _ability._data.effect.create_handler(_ability, _context)
	_effect_handler.finished.connect(_exec.finish)
	_effect_handler.canceled.connect(_exec.abort)
	
	_effect_handler.setup(_ability._data.effect)
	_effect_handler.execute(_exec.blackboard.aiming_result)

func tick(delta: float) -> void:
	_effect_handler.tick(delta)

func release() -> void:
	_effect_handler.release()

func _to_string() -> String:
	return "CharacterAbilityExecutionExecute"

func cancel() -> void:
	_effect_handler.cancel()
