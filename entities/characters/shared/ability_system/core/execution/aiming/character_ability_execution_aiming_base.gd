class_name CharacterAbilityExecutionAimingBase extends RefCounted

signal target_aquired(result: CharacterAbilityAimingResult)
signal canceled()

var _context: CharacterAbilityAimingContext

func _init(
	context: CharacterAbilityAimingContext,
) -> void:
	_context = context

func setup(_data: CharacterAbilityTargeting) -> void:
	_emit_target_aquired(CharacterAbilityAimingResult.new())

func handle_input(_event: InputEvent) -> bool:
	return false

func tick(_delta: float) -> void:
	pass

func cancel() -> void:
	pass

func _emit_target_aquired(result: CharacterAbilityAimingResult) -> void:
	target_aquired.emit(result)

func _emit_cancel() -> void:
	cancel()
	canceled.emit()
