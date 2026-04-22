class_name AbilityExecutionPhase extends RefCounted

var _exec: AbilityExecuter
var _ability: Ability

func _init(
	exec: AbilityExecuter,
	ability: Ability,
) -> void:
	_exec = exec
	_ability = ability

func start() -> void:
	pass

func release() -> void:
	pass

func cancel() -> void:
	pass

func animation_trigger() -> void:
	pass

func hit_event(_target: Node3D) -> void:
	pass

func tick(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> bool:
	return false

func _to_string() -> String:
	return "AbilityExecutionBase"
