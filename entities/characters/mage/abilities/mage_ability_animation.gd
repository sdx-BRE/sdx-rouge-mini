class_name MageAbilityAnimation extends RefCounted

var oneshot_prop: StringName

func _init(
	p_oneshot_prop: StringName,
) -> void:
	oneshot_prop = p_oneshot_prop

static func from_data(animation: MageAnimationData) -> MageAbilityAnimation:
	return MageAbilityAnimation.new(animation.oneshot_property)
