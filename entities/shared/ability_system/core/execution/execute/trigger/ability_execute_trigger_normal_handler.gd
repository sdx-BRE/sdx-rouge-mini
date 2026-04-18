class_name AbilityExecuteTriggerNormalHandler extends AbilityExecuteTriggerHandler

func start() -> void:
	_emit_triggered()
	_emit_finished()
