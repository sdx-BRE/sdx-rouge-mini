class_name CharacterAbilityExecuteTriggerNormalHandler extends CharacterAbilityExecuteTriggerHandler

func start() -> void:
	_emit_triggered()
	_emit_finished()
