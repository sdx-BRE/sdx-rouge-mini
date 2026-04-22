class_name AbilityExecutionBlackboard extends RefCounted

var aiming_result: AbilityAimingResult
var hit_targets: Array[Node3D] = []
var is_released := false

func cleanup() -> void:
	aiming_result = null
	hit_targets.clear()
	is_released =  false
