class_name ProjectileHomingBase extends RefCounted

var _projectile: BaseProjectile

func _init(
	projectile: BaseProjectile,
) -> void:
	_projectile = projectile

func steer(delta: float) -> void:
	push_error("[Error][ProjectileHomingBase]: steer() must be overwritten by child implementations, delta: ", delta)

func _steer_to(target_pos: Vector3, delta: float) -> void:
	if _projectile.global_position.is_equal_approx(target_pos):
		return
	
	var direction := (target_pos - _projectile.global_position).normalized()
	var forward := -_projectile.global_basis.z
	
	var dot := forward.dot(direction)
	if dot <= _projectile._homing_fov:
		return
	
	var up_vector := Vector3.UP
	if abs(direction.y) > 0.999:
		up_vector = Vector3.RIGHT
	
	var target_transform := _projectile.global_transform.looking_at(target_pos, up_vector)
	
	var current_quat := _projectile.global_transform.basis.get_rotation_quaternion()
	var target_quat := target_transform.basis.get_rotation_quaternion()
	
	var final_quat := current_quat.slerp(target_quat, delta * _projectile._homing_steer_speed)
	_projectile.global_transform.basis = Basis(final_quat)
