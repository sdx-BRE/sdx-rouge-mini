class_name AbilityRecoverWindupAnimationChannelingHandler extends AbilityRecoverWindupHandler

var _data: AbilityWindupAnimationChanneling

func setup(data: AbilityWindup) -> void:
	_data = data

func recover() -> void:
	_context.fadeout_oneshot(_data.anim_trigger)

func cancel() -> void:
	_context.fadeout_oneshot(_data.anim_trigger)
