class_name CharacterAbilitySetupAnimationHandler extends CharacterAbilitySetupWindupHandler

var _data: CharacterAbilityWindupAnimation

func setup(data: CharacterAbilityWindup) -> void:
	_data = data

func start() -> void:
	_context.update_cast_point(_data)
	_context.animate(_data)
	_context.notify_casting_started()

func tick() -> void:
	_context.notify_casting_progressed(
		_context.get_animation_position(_data),
		_data.cast_point,
	)

func trigger() -> void:
	_context.notify_casting_end()
	_emit_visual_ready()

func cancel() -> void:
	_context.cancel_animation(_data)
	_context.notify_casting_end()
