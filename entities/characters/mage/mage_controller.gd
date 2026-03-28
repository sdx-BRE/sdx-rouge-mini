class_name MageController extends RefCounted

var _ctx: MageMovementContext

func _init(context: MageMovementContext) -> void:
	_ctx = context

func get_speed() -> float:
	return Vector3(_ctx.host.velocity.x, 0, _ctx.host.velocity.z).length()

func is_not_moving() -> bool:
	return is_zero_approx(get_speed())

func is_on_floor() -> bool:
	return _ctx.motion.coyote_timer > 0

func push_dash_motion(dash_power: Vector3) -> void:
	_ctx.motion.dash_power = dash_power

func jump() -> void:
	if _motion.coyote_timer > 0:
		_host.velocity.y = _config.get_jump_impulse_velocity()
		_motion.coyote_timer = 0
