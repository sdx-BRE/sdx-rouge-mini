class_name CharacterAbilityExecutionBase extends RefCounted

var _exec: CharacterAbilityExecution

func _init(exec: CharacterAbilityExecution) -> void:
	_exec = exec

func start() -> void:
	pass

func release() -> void:
	pass

func cancel() -> void:
	pass

func animation_trigger() -> void:
	pass

func tick(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> bool:
	return false

func _to_string() -> String:
	return "CharacterAbilityExecutionBase"
