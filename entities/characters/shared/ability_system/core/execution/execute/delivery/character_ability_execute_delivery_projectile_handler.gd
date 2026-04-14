class_name CharacterAbilityExecuteDeliveryProjectileHandler extends CharacterAbilityExecuteDeliveryHandler

var _data: CharacterAbilityDeliveryProjectile

func setup(data: CharacterAbilityDelivery) -> void:
	_data = data

func execute(aiming_result: CharacterAbilityAimingResult) -> void:
	var node := _data.scene.instantiate()
	
	_setup_when_ability(node, _data)
	aiming_result.set_projectile_target(node, _context)
	
	_emit_cost_required()
	_spawn_ability(node)
	_launch_when_ability(node, _data)

func _spawn_ability(node: Node3D) -> void:
	_context.spawn_at_wand(node)
	node.global_basis = _context.get_pivot_basis()
