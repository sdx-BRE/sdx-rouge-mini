class_name AbilityExecuteDeliveryProjectileHandler extends AbilityExecuteDeliveryHandler

var _data: AbilityDeliveryProjectile

func setup(data: AbilityDelivery) -> void:
	_data = data as AbilityDeliveryProjectile

func execute(aiming_result: AbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	
	_setup_when_ability(node, _data)
	aiming_result.set_projectile_target(node, _context)
	
	_emit_cost_required()
	_spawn_ability(node)
	
	aiming_result.launch_projectile(node, _context)
	_launch_when_ability(node, _data)

func _spawn_ability(node: Node3D) -> void:
	_context.spawn_at_weapon(node)
	node.global_basis = _context.get_pivot_basis()
