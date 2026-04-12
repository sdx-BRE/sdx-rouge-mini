class_name MCharacterAbilityExecutionSetupTriggerHandler extends RefCounted

signal execution_requested()

var _context: MCharacterAbilityExecutionSetupContext

func _init(
	context: MCharacterAbilityExecutionSetupContext,
) -> void:
	_context = context

func setup(_data: MCharacterAbilityTrigger) -> void:
	pass

func start() -> void:
	pass

func release() -> void:
	pass

func tick(_delta: float) -> void:
	pass

func _emit_execution_requested() -> void:
	execution_requested.emit()
