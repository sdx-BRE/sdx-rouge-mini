class_name CharacterAbilityTriggerHandler extends RefCounted

var _exec: CharacterAbilityExecution
var _effect: CharacterAbilityExecutionExecuteEffectHandler

func _init(
	exec: CharacterAbilityExecution,
	effect: CharacterAbilityExecutionExecuteEffectHandler,
) -> void:
	_exec = exec
	_effect = effect

func setup(_data: CharacterAbilityTrigger) -> void:
	pass

func start() -> void:
	pass

func tick(_delta: float) -> void:
	pass

func release() -> void:
	pass

func cancel() -> void:
	pass
