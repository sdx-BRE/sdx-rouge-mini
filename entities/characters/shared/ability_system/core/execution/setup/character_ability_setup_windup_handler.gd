class_name CharacterAbilitySetupWindupHandler extends RefCounted

signal visual_ready()

var _context: CharacterAbilitySetupContext

func _init(
	context: CharacterAbilitySetupContext,
) -> void:
	_context = context

func setup(_data: CharacterAbilityWindup) -> void:
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
