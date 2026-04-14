class_name CharacterAbilityExecutionBlackboard extends RefCounted

var aiming_result: CharacterAbilityAimingResult
var is_released := false

func cleanup() -> void:
	aiming_result = null
	is_released =  false
