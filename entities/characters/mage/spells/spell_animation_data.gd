class_name SpellAnimationData extends MageAnimationData

@export var animation_name: StringName

const CALL_METHOD_TRACK_NAME := &"execute_cast"

func try_get_call_method_track_time(player: AnimationPlayer):
	return AnimationUtil.try_get_call_method_track_time(player, animation_name, CALL_METHOD_TRACK_NAME)
