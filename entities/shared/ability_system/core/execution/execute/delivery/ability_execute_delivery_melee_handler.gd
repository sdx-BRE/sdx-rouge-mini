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
		
		_asd(target)
	
	_emit_cost_required()

func _asd(target: Node3D) -> void:
	var target_point: Node3D = target
	if target.has_method(&"get_target_point"):
		target_point = target.get_target_point()
	
	for hit_effect in _data.hit_effects:
		var node := hit_effect.instantiate()
		_context.spawn_node(node)
		node.global_position = target_point.global_position
