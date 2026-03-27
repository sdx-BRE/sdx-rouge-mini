class_name MageMovementConfig extends RefCounted

var camera_node: ThirdPersonCam
var movement_speed: float
var dash_decay: float
var look_at_weight: float
var jump_height: float
var time_to_peak: float
var time_to_descent: float
var apex_threshold: float
var apex_gravity_multiplier: float
var coyote_time: float

func _init(
	p_camera_node: ThirdPersonCam,
	p_movement_speed: float,
	p_dash_decay: float,
	p_look_at_weight: float,
	p_jump_height: float,
	p_time_to_peak: float,
	p_time_to_descent: float,
	p_apex_threshold: float,
	p_apex_gravity_multiplier: float,
	p_coyote_time: float,
) -> void:
	camera_node = p_camera_node
	movement_speed = p_movement_speed
	dash_decay = p_dash_decay
	look_at_weight = p_look_at_weight
	jump_height = p_jump_height
	time_to_peak = p_time_to_peak
	time_to_descent = p_time_to_descent
	apex_threshold = p_apex_threshold
	apex_gravity_multiplier = p_apex_gravity_multiplier
	coyote_time = p_coyote_time

static func from_mage(mage: MageCharacter) -> MageMovementConfig:
	return MageMovementConfig.new(
		mage.camera_node,
		mage.data.max_speed,
		mage.data.dash_decay,
		mage.look_at_weight,
		mage.data.jump_height,
		mage.data.time_to_peak,
		mage.data.time_to_descent,
		mage.data.apex_threshold,
		mage.data.apex_gravity_multiplier,
		mage.data.coyote_time,
	)

func get_jump_gravity() -> float:
	return (2 * jump_height) / (time_to_peak * time_to_peak)

func get_fall_gravity() -> float:
	return (2 * jump_height) / (time_to_descent * time_to_descent)

func get_jump_impulse_velocity() -> float:
	return get_jump_gravity() * time_to_peak * 1
