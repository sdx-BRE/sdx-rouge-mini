class_name MageSensors extends RefCounted

var _movement_ctx: MageMovementContext

func _init(movement_ctx: MageMovementContext) -> void:
	_movement_ctx = movement_ctx 

func physics_update(delta: float) -> void:
	_movement_ctx.motion.jump_buffer_timer = max(_movement_ctx.motion.jump_buffer_timer - delta, 0.0)
	
	if not _movement_ctx.host.is_on_floor():
		_movement_ctx.motion.coyote_timer = max(_movement_ctx.motion.coyote_timer - delta, 0.0)
