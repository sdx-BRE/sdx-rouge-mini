class_name MCharacterAbilityExecutionBase extends RefCounted

var _exec: MCharacterAbilityExecution

func _init(exec: MCharacterAbilityExecution) -> void:
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
