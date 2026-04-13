class_name MCharacterAbilityExecutionExecute extends MCharacterAbilityExecutionBase

var _data: MCharacterAbilityData
var _context: MCharacterAbilityExecutionExecuteContext

var _effect_handler: MCharacterAbilityExecutionExecuteEffectHandler

func _init(
	exec: MCharacterAbilityExecution,
	data: MCharacterAbilityData,
	context: MCharacterAbilityExecutionExecuteContext,
) -> void:
	super(exec)
	_data = data
	_context = context

func start() -> void:
	_effect_handler = _data.effect.create_handler(_context)
	_effect_handler.finished.connect(_exec.finish)
	
	_effect_handler.setup(_data.effect)
	_effect_handler.execute(_exec.blackboard.aiming_result)

func tick(delta: float) -> void:
	_effect_handler.tick(delta)

func release() -> void:
	_effect_handler.release()

func _to_string() -> String:
	return "MCharacterAbilityExecutionExecute"
