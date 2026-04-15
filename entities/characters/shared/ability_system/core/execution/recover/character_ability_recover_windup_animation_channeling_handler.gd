class_name CharacterAbilityRecoverWindupAnimationChannelingHandler extends CharacterAbilityRecoverWindupHandler

var _data: CharacterAbilityWindupAnimationChanneling

func setup(data: CharacterAbilityWindup) -> void:
	_data = data

func recover() -> void:
	_context.fadeout_oneshot(_data.anim_trigger)

func cancel() -> void:
	_context.fadeout_oneshot(_data.anim_trigger)
