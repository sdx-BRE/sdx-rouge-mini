class_name AbilityExecuteDeliveryDashHandler extends AbilityExecuteDeliveryHandler

var _data: AbilityDeliveryDash

func setup(data: AbilityDelivery) -> void:
	_data = data

func execute(_aiming_result: AbilityAimingResult) -> void:
	_emit_cost_required()
	
	_context.push_dash_motion(_data.dash_power)
