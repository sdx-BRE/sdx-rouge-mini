class_name NCharacterAbilityExecution extends Resource

func get_handler() -> NCharacterAbilityHandler.Execution:
	push_warning("[NCharacterAbilityExecution.get_handler()]: must be overriden by child implementations")
	return NCharacterAbilityHandler.Execution.Instant
