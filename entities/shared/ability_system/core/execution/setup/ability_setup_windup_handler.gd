class_name AbilitySetupWindupHandler extends RefCounted

signal visual_ready()

var _context: AbilitySetupContext
var _blackboard: AbilityExecutionBlackboard

func _init(
	context: AbilitySetupContext,
	blackboard: AbilityExecutionBlackboard,
) -> void:
	_context = context
	_blackboard = blackboard

func setup(_data: AbilityWindup) -> void:
	pass

func start() -> void:
	pass

func tick(_delta: float) -> void:
	pass

func trigger() -> void:
	pass

func hit_event(_target: Node3D) -> void:
	pass

func cancel() -> void:
	pass

func _emit_visual_ready() -> void:
	visual_ready.emit()
