class_name CharacterAbilityAimingResultMouseTarget extends CharacterAbilityAimingResult

var target: Node3D

func _init(target_node: Node3D) -> void:
	target = target_node

func set_projectile_target(projectile: BaseProjectile, _context: CharacterAbilityExecuteContext) -> void:
	projectile._target = target

func set_aoe_position(aoe: BaseAoe, _context: CharacterAbilityExecuteContext) -> void:
	if target != null:
		aoe.global_position = target.global_position
