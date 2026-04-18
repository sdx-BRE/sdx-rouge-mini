class_name AbilityExecuteDeliverySprintHandler extends AbilityExecuteDeliveryHandler

var _data: AbilityDeliverySprint

func setup(data: AbilityDelivery) -> void:
	_data = data

func execute(_aiming_result: AbilityAimingResult) -> void:
	_context.use_sprinting_speed()

func release() -> void:
	_context.use_normal_speed()

func tick(delta: float) -> void:
	_emit_continuous_cost_required(delta)
