class_name CharacterAbilityExecutionPhase extends RefCounted

var _exec: CharacterAbilityExecuter

func _init(exec: CharacterAbilityExecuter) -> void:
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
