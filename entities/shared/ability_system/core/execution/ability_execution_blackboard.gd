class_name AbilityExecutionBlackboard extends RefCounted

var aiming_result: AbilityAimingResult
var is_released := false

func cleanup() -> void:
	aiming_result = null
	is_released =  false
