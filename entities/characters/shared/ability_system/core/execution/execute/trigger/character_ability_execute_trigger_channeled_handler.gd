class_name CharacterAbilityExecuteTriggerChanneledHandler extends CharacterAbilityExecuteTriggerHandler

func start() -> void:
	if _blackboard.is_released:
		_emit_finished()
		return
	_emit_triggered()

func tick(_delta: float) -> void:
	if _blackboard.is_released:
		_emit_finished()
		return
	_emit_triggered()

func release() -> void:
	_emit_finished()
