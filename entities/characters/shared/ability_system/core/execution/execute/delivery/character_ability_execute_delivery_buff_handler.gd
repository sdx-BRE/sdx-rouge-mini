class_name CharacterAbilityExecuteDeliveryBuffHandler extends CharacterAbilityExecuteDeliveryHandler

var _data: CharacterAbilityDeliveryBuff

func setup(data: CharacterAbilityDelivery) -> void:
	_data = data

func execute(_aiming_result: CharacterAbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	
	_setup_when_ability(node, _data)
	_emit_cost_required()
	
	_context.spawn_buff(node)
	_launch_when_ability(node, _data)
