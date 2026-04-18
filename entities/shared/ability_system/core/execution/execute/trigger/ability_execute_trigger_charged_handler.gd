class_name AbilityExecuteTriggerChargedHandler extends AbilityExecuteTriggerHandler

func start() -> void:
	_emit_triggered()
	_emit_finished()
