class_name CharacterAbilityRecoverWindupHandler extends RefCounted

var _context: CharacterAbilityRecoverContext

func _init(
	context: CharacterAbilityRecoverContext,
) -> void:
	_context = context

func setup(_data: CharacterAbilityWindup) -> void:
	pass

func recover() -> void:
	pass

func cancel() -> void:
	pass
