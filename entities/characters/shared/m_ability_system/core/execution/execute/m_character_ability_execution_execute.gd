class_name MCharacterAbilityExecutionExecute extends MCharacterAbilityExecutionBase

var _ability: MCharacterAbility
var _context: MCharacterAbilityExecutionExecuteContext

var _effect_handler: MCharacterAbilityExecutionExecuteEffectHandler

func _init(
	exec: MCharacterAbilityExecution,
	ability: MCharacterAbility,
	context: MCharacterAbilityExecutionExecuteContext,
) -> void:
	super(exec)
	_ability = ability
	_context = context

func start() -> void:
	_effect_handler = _ability._data.effect.create_handler(_ability, _context)
	_effect_handler.finished.connect(_exec.finish)
	
	_effect_handler.setup(_ability._data.effect)
	_effect_handler.execute(_exec.blackboard.aiming_result)

func tick(delta: float) -> void:
	_effect_handler.tick(delta)

func release() -> void:
	_effect_handler.release()

func _to_string() -> String:
	return "MCharacterAbilityExecutionExecute"
