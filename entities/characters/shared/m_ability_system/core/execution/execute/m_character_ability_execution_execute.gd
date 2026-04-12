class_name MCharacterAbilityExecutionExecute extends MCharacterAbilityExecutionBase

var _data: MCharacterAbilityData
var _context: MCharacterAbilityExecutionExecuteContext

func _init(
	exec: MCharacterAbilityExecution,
	data: MCharacterAbilityData,
	context: MCharacterAbilityExecutionExecuteContext,
) -> void:
	super(exec)
	_data = data
	_context = context

func start() -> void:
	var effect_handler := _data.effect.create_handler(_context) 
	
	
	pass
