class_name MCharacterAbilityExecutionExecuteEffectHandler extends RefCounted

signal finished()
signal canceled()

var _context: MCharacterAbilityExecutionExecuteContext

func _init(context: MCharacterAbilityExecutionExecuteContext) -> void:
	_context = context

func setup(_data: MCharacterAbilityEffect) -> void:
	pass

func execute(_aiming_result: McharacterAbilityAimingResult) -> void:
	pass

func tick(_delat: float) -> void:
	pass

func release() -> void:
	pass

func _emit_finished() -> void:
	finished.emit()

func _emit_canceled() -> void:
	canceled.emit()
