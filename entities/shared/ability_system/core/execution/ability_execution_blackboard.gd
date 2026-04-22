class_name AbilityExecutionBlackboard extends RefCounted

var aiming_result: AbilityAimingResult
var hit_targets: Array[Node3D] = []
var is_released := false
var is_cancelled := false

func cleanup() -> void:
	aiming_result = null
	hit_targets.clear()
	is_released = false
	is_cancelled = false
