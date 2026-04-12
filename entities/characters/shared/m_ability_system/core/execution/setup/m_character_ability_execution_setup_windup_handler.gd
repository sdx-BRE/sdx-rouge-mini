class_name MCharacterAbilityExecutionSetupWindupHandler extends RefCounted

signal visual_ready()

var _context: MCharacterAbilityExecutionSetupContext

func _init(
	context: MCharacterAbilityExecutionSetupContext,
) -> void:
	_context = context

func setup(_data: MCharacterAbilityWindup) -> void:
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
