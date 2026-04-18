class_name AbilityExecuteDeliveryBuffHandler extends AbilityExecuteDeliveryHandler

var _data: AbilityDeliveryBuff

func setup(data: AbilityDelivery) -> void:
	_data = data

func execute(_aiming_result: AbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	
	_setup_when_ability(node, _data)
	_emit_cost_required()
	
	_context.spawn_buff(node)
	_launch_when_ability(node, _data)
