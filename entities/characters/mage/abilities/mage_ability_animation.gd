class_name MageAbilityAnimation extends RefCounted

var trigger: StringName

func _init(
	p_trigger: StringName,
) -> void:
	trigger = p_trigger

static func from_data(animation: MageAnimationData) -> MageAbilityAnimation:
	return MageAbilityAnimation.new(animation.anim_trigger)
