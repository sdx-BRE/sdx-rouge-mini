class_name CharacterAbilityExecutionPhase extends RefCounted

var _exec: CharacterAbilityExecuter
var _ability: CharacterAbility

func _init(
	exec: CharacterAbilityExecuter,
	ability: CharacterAbility,
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

func tick(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> bool:
	return false

func _to_string() -> String:
	return "CharacterAbilityExecutionBase"
