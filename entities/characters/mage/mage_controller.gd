class_name MageController extends RefCounted

var _host: CharacterBody3D
var _config: MageMovementConfig
var _motion: MageMovementMotion

func _init(host: CharacterBody3D, config: MageMovementConfig, motion: MageMovementMotion) -> void:
	_host = host
	_config = config
	_motion = motion

func get_speed() -> float:
	return Vector3(_host.velocity.x, 0, _host.velocity.z).length()

func is_not_moving() -> bool:
	return is_zero_approx(get_speed())

func is_on_floor() -> bool:
	return _motion.coyote_timer > 0

func push_dash_motion(dash_power: Vector3) -> void:
	_motion.dash_power = dash_power

func jump() -> void:
	if _motion.coyote_timer > 0:
		_host.velocity.y = _config.get_jump_impulse_velocity()
		_motion.coyote_timer = 0
