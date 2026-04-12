class_name McharacterAbilityAimingResultMouseTarget extends McharacterAbilityAimingResult

var target: Node3D

func _init(target_node: Node3D) -> void:
	target = target_node

func set_projectile_target(projectile: BaseProjectile) -> void:
	projectile._target = target
