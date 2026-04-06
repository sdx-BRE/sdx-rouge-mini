class_name ProjectilePredictiveHoming extends ProjectileHomingBase

var _target: CharacterBody3D
var _target_point: Node3D

func _init(
	projectile: BaseProjectile,
	target: CharacterBody3D
) -> void:
	super(projectile)
	_target = target
	_safe_set_target_point(target)

func steer(delta: float) -> void:
	var target_pos := _predict_target_position(_target_point.global_position, _target.velocity)
	_steer_to(target_pos, delta)

func _predict_target_position(target_pos: Vector3, target_velocity: Vector3) -> Vector3:
	var to_target := target_pos - _projectile.global_position
	var distance := to_target.length()
	
	if _projectile._speed <= 0.001:
		return target_pos
	
	var t := distance / _projectile._speed
	return target_pos + target_velocity * t

func _safe_set_target_point(target: Node3D) -> void:
	if target.has_method("get_target_point"):
		var target_point = target.get_target_point()
		if target_point is Node3D:
			_target_point = target_point
			return
	
	_target_point = target
