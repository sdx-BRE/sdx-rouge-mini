class_name MCharacterAbilityExecutionExecuteEffectHandler extends RefCounted

var _context: MCharacterAbilityExecutionExecuteContext

func _init(context: MCharacterAbilityExecutionExecuteContext) -> void:
	_context = context

func setup(_data: MCharacterAbilityEffect) -> void:
	pass

func execute(_aiming_result: McharacterAbilityAimingResult) -> void:
	pass
