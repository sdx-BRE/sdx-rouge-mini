class_name ProjectileSimpleHoming extends ProjectileHomingBase

var _target: Node3D

func _init(
	projectile: BaseProjectile,
	target: Node3D,
) -> void:
	_projectile = projectile
	_safe_set_target(target)

func steer(delta: float) -> void:
	_steer_to(_target.global_position, delta)

func _safe_set_target(target: Node3D) -> void:
	if target.has_method("get_target_point"):
		var target_point = target.get_target_point()
		if target_point is Node3D:
			_target = target_point
			return
	
	_target = target
