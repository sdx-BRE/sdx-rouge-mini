class_name CharacterAbilityExecuteDeliverySprintHandler extends CharacterAbilityExecuteDeliveryHandler

var _data: CharacterAbilityDeliverySprint

func setup(data: CharacterAbilityDelivery) -> void:
	_data = data

func execute(_aiming_result: CharacterAbilityAimingResult) -> void:
	_context.use_sprinting_speed()

func release() -> void:
	_context.use_normal_speed()

func tick(delta: float) -> void:
	_emit_continuous_cost_required(delta)
