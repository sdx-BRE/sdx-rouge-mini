class_name CharacterAbilityExecuteTriggerHandler extends RefCounted

var _exec: CharacterAbilityExecuter
var _effect: CharacterAbilityExecuteEffectHandler

func _init(
	exec: CharacterAbilityExecuter,
	effect: CharacterAbilityExecuteEffectHandler,
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
