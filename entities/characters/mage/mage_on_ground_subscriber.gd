class_name MageOnGroundSubscriber extends SubscriberAirbourne

var _anim: MageAnimator
var _param_land_oneshot: StringName

func _init(anim: MageAnimator, param_land_oneshot: StringName) -> void:
	_anim = anim
	_param_land_oneshot = param_land_oneshot

func handle() -> void:
	_anim.request_oneshot_fire(_param_land_oneshot)
