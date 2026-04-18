class_name AbilitySetupOneshotStatemachineAnimationHandler extends AbilitySetupWindupHandler

var _data: AbilityWindupAnimationChanneling

func setup(data: AbilityWindup) -> void:
	_data = data

func start() -> void:
	_context.oneshot(_data.anim_trigger)

func cancel() -> void:
	_context.cancel_oneshot(_data.anim_trigger)
	_context.notify_casting_end()
