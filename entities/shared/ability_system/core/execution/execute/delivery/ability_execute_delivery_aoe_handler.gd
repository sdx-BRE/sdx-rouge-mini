class_name AbilityExecuteDeliveryAoeHandler extends AbilityExecuteDeliveryHandler

var _data: AbilityDeliveryAoe

func setup(data: AbilityDelivery) -> void:
	_data = data

func execute(aiming_result: AbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	
	_setup_when_ability(node, _data)
	_spawn_ability(node)
	
	aiming_result.set_aoe_position(node, _context)
	_launch_when_ability(node, _data)

func _spawn_ability(node: Node3D) -> void:
	_emit_cost_required()
	_context.spawn_at_weapon(node)
	node.global_basis = _context.get_pivot_basis()
