class_name CharacterAbilityExecuteTriggerHandler extends RefCounted

signal triggered()
signal triggered_tick(timespan: float)
signal finished()

var _blackboard: CharacterAbilityExecutionBlackboard

func _init(blackboard: CharacterAbilityExecutionBlackboard) -> void:
	_blackboard = blackboard

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

func _emit_triggered() -> void:
	triggered.emit()

func _emit_triggered_tick(timespan: float) -> void:
	triggered_tick.emit(timespan)

func _emit_finished() -> void:
	finished.emit()
