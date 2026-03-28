class_name MageMotor extends RefCounted

var _ctx: MageMovementContext

func _init(context: MageMovementContext) -> void:
	_ctx = context

func apply_impulses(_delta: float) -> void:
	DbgHelper.tprint("[MageMotor::apply_impulses]")
	DbgHelper.tprint("jump_buffer_timer: ", _ctx.motion.jump_buffer_timer, " coyote_timer: ", _ctx.motion.coyote_timer)
	print()
	
	
	if _ctx.motion.jump_buffer_timer > 0 and _ctx.motion.coyote_timer > 0:
		_ctx.host.velocity.y = _ctx.config.get_jump_impulse_velocity()
		_ctx.motion.coyote_timer = 0
		_ctx.motion.jump_buffer_timer = 0
