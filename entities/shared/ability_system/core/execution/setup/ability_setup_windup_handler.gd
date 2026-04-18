class_name AbilitySetupWindupHandler extends RefCounted

signal visual_ready()

var _context: AbilitySetupContext

func _init(
	context: AbilitySetupContext,
) -> void:
	_context = context

func setup(_data: AbilityWindup) -> void:
	pass

func start() -> void:
	pass

func tick() -> void:
	pass

func trigger() -> void:
	pass

func cancel() -> void:
	pass

func _emit_visual_ready() -> void:
	visual_ready.emit()
