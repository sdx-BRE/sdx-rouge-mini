class_name AbilityAimingResultMouseTarget extends AbilityAimingResult

var target: Node3D

func _init(target_node: Node3D) -> void:
	target = target_node

func set_projectile_target(projectile: BaseProjectile, _context: AbilityExecuteContext) -> void:
	projectile._target = target

func set_aoe_position(aoe: BaseAoe, _context: AbilityExecuteContext) -> void:
	if target != null:
		aoe.global_position = target.global_position
