class_name CharacterDashAbility extends CharacterInstantAbility

var _dash_data: CharacterAbilityDash

func _init(data: CharacterAbilityDash, context: InstantContext) -> void:
	super(data, context)
	_dash_data = data

func trigger(state: CharacterAbilitySystem.TriggerState) -> Result:
	if state != CharacterAbilitySystem.TriggerState.Press or _context.is_not_moving():
		return Result.Abort
	
	_context.push_dash_motion(_dash_data.dash_power)
	_context.request_oneshot(_dash_data.anim_trigger)
	
	return Result.Trigger
