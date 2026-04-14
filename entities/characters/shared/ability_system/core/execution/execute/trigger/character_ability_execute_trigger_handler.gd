class_name CharacterAbilityExecuteTriggerHandler extends RefCounted

var _exec: CharacterAbilityExecuter
var _delivery: CharacterAbilityExecuteDeliveryHandler

func _init(
	exec: CharacterAbilityExecuter,
	delivery: CharacterAbilityExecuteDeliveryHandler,
) -> void:
	_exec = exec
	_delivery = delivery

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
