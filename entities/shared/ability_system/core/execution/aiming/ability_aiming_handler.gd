class_name AbilityAimingHandler extends RefCounted

signal target_aquired(result: AbilityAimingResult)
signal canceled()

var _context: AbilityAimingContext

func _init(
	context: AbilityAimingContext,
) -> void:
	_context = context

func setup(_data: AbilityTargeting) -> void:
	_emit_target_aquired(AbilityAimingResult.new())

func handle_input(_event: InputEvent) -> AbilityHandleInputResult:
	return AbilityHandleInputResult.unhandled()

func tick(_delta: float) -> void:
	pass

func cancel() -> void:
	pass

func _emit_target_aquired(result: AbilityAimingResult) -> void:
	target_aquired.emit(result)

func _emit_cancel() -> void:
	cancel()
	canceled.emit()
