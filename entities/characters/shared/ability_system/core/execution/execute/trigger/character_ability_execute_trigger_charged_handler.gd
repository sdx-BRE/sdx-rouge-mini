class_name CharacterAbilityExecuteTriggerChargedHandler extends CharacterAbilityExecuteTriggerHandler

func start() -> void:
	_emit_triggered()
	_emit_finished()
