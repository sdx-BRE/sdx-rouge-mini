class_name MageController extends RefCounted

var _ctx: MageMovementContext

func _init(context: MageMovementContext) -> void:
	_ctx = context

func get_speed() -> float:
	return Vector3(_ctx.host.velocity.x, 0, _ctx.host.velocity.z).length()

func is_not_moving() -> bool:
	return is_zero_approx(get_speed())

func buffer_jump() -> void:
	_ctx.motion.jump_buffer_timer = _ctx.config.jump_buffer_time

func push_dash_motion(dash_power: Vector3) -> void:
	_ctx.motion.dash_power = dash_power

func use_normal_speed() -> void:
	_ctx.motion.target_speed = _ctx.config.speed_normal

func use_sprinting_speed() -> void:
	_ctx.motion.target_speed = _ctx.config.speed_sprinting
