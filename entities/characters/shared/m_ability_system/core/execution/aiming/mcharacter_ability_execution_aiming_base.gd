class_name MCharacterAbilityExecutionAimingBase extends RefCounted

signal target_aquired(result: McharacterAbilityAimingResult)
signal canceled()

var _context: MCharacterAbilityExecutionAimingContext

func _init(
	context: MCharacterAbilityExecutionAimingContext,
) -> void:
	_context = context

func setup(_data: MCharacterAbilityTargeting) -> void:
	_emit_target_aquired(McharacterAbilityAimingResult.new())

func handle_input(_event: InputEvent) -> bool:
	return false

func tick(_delta: float) -> void:
	pass

func cancel() -> void:
	pass

func _emit_target_aquired(result: McharacterAbilityAimingResult) -> void:
	target_aquired.emit(result)

func _emit_cancel() -> void:
	cancel()
	canceled.emit()
