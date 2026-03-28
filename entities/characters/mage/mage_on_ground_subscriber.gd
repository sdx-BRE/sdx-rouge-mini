class_name MageOnGroundSubscriber extends SubscriberAirbourne

var _anim: MageAnimator
var _movement_context: MageMovementContext
var _param_land_oneshot: StringName

func _init(
	anim: MageAnimator, 
	movement_context: MageMovementContext, 
	param_land_oneshot: StringName
) -> void:
	_anim = anim
	_movement_context = movement_context
	_param_land_oneshot = param_land_oneshot

func handle() -> void:
	_anim.request_oneshot_fire(_param_land_oneshot)
	_movement_context.reset_coyote_timer()
