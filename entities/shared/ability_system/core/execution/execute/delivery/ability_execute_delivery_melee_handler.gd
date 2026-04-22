class_name AbilityExecuteDeliveryMeleeHandler extends AbilityExecuteDeliveryHandler

var _data: AbilityDeliveryMelee

func setup(data: AbilityDelivery) -> void:
	_data = data

func execute(_aiming_result: AbilityAimingResult) -> void:
	var targets := _blackboard.hit_targets
	
	if targets.is_empty():
		return
	
	for target in targets:
		if target.has_method("take_damage"):
			var damage_instance := DamageInstance.from_ability(_data.damage)
			target.take_damage(damage_instance)
	
	_emit_cost_required()
