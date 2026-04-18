class_name AbilityRecoverWindupHandler extends RefCounted

var _context: AbilityRecoverContext

func _init(
	context: AbilityRecoverContext,
) -> void:
	_context = context

func setup(_data: AbilityWindup) -> void:
	pass

func recover() -> void:
	pass

func cancel() -> void:
	pass
