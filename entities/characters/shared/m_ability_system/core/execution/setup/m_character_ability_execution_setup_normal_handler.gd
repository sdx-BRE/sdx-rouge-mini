class_name MCharacterAbilityExecutionSetupNormalHandler extends MCharacterAbilityExecutionSetupTriggerHandler

func start() -> void:
	print("normal request exec")
	_emit_execution_requested()
