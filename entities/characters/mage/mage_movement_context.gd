class_name MageMovementContext extends RefCounted

var host: CharacterBody3D
var config: MageMovementConfig
var motion: MageMovementMotion

func _init(
	p_host: CharacterBody3D,
	p_config: MageMovementConfig,
	p_motion: MageMovementMotion,
) -> void:
	host = p_host
	config = p_config
	motion = p_motion

func reset_coyote_timer() -> void:
	motion.coyote_timer = config.coyote_time
