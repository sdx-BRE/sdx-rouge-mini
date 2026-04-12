class_name MCharacterAbilityExecutionSetupAnimationHandler extends MCharacterAbilityExecutionSetupWindupHandler

var _data: McharacterAbilityWindupAnimation

func setup(data: MCharacterAbilityWindup) -> void:
	_data = data

func start() -> void:
	print("start anim...")
	_context.update_cast_point(_data) # Todo: double check if it is necessary here
	_context.animate(_data)
	_context.notify_casting_started()

func tick() -> void:
	_context.notify_casting_progressed(
		_context.get_animation_position(_data),
		_data.cast_point,
	)

func trigger() -> void:
	print("anim trigger received, visual ready")
	_context.notify_casting_end()
	_emit_visual_ready()
