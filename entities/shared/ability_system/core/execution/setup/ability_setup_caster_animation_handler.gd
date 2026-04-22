class_name AbilitySetupCasterAnimationHandler extends AbilitySetupWindupHandler

var _data: AbilityWindupCasterAnimation

func setup(data: AbilityWindup) -> void:
	_data = data

func start() -> void:
	_context.update_cast_point(_data)
	_context.oneshot(_data.anim_trigger)
	_context.notify_casting_started()

func tick(_delta: float) -> void:
	_context.notify_casting_progressed(
		_context.get_animation_position(_data),
		_data.cast_point,
	)

func trigger() -> void:
	_context.notify_casting_end()
	_emit_visual_ready()

func cancel() -> void:
	_context.cancel_oneshot(_data.anim_trigger)
	_context.notify_casting_end()
