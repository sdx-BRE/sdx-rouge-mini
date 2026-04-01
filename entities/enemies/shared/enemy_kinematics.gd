class_name EnemyKinematics extends RefCounted

const FRAMES_TO_STOP := 8.0

var _ctx: EnemyMovementContext

func _init(ctx: EnemyMovementContext) -> void:
	_ctx = ctx

func update_velocity(delta: float) -> void:
	_handle_rotation(delta)
	
	if _ctx.motion.is_movement_enabled: 
		_move_to_target(delta)
	else: 
		_stop_moving()

func handle_gravity(delta: float) -> void:
	if not _ctx.host.is_on_floor():
		_ctx.host.velocity += _ctx.host.get_gravity() * delta

func get_horizontal_speed() -> float:
	return Vector3(_ctx.host.velocity.x, 0, _ctx.host.velocity.z).length()

func move_and_slide() -> void:
	_ctx.host.move_and_slide()

func _move_to_target(_delta: float) -> void:
	var next_pos := _ctx.agent.get_next_path_position()
	var direction := (next_pos - _ctx.host.global_position)
	direction.y = 0.0
	direction = direction.normalized()
	
	var desired_velocity := direction * _ctx.motion.speed
	_ctx.agent.set_velocity(desired_velocity)
	_ctx.host.velocity = _ctx.agent.get_velocity()

func _handle_rotation(delta: float) -> void:
	var target_direction := Vector3.ZERO
	
	if _ctx.motion.is_target_rotation_enabled:
		target_direction = (_ctx.motion.rotate_to_target - _ctx.host.global_position)
		
	elif _ctx.motion.is_movement_enabled:
		var next_pos := _ctx.agent.get_next_path_position()
		target_direction = (next_pos - _ctx.host.global_position)
	
	target_direction.y = 0.0 
	
	if not target_direction.is_zero_approx():
		_rotate_to(target_direction.normalized(), delta)

func _rotate_to(direction: Vector3, delta: float) -> void:
	var target_angle := atan2(-direction.x,-direction.z)
	
	_ctx.host.rotation.y = lerp_angle(
		_ctx.host.rotation.y, 
		target_angle, 
		delta * _ctx.config.look_at_weight
	)

func _stop_moving() -> void:
	if get_horizontal_speed() > 0:
		var friction := maxf(_ctx.motion.speed, _ctx.config.walking_speed) / FRAMES_TO_STOP
		_apply_friction(friction)
		
		if get_horizontal_speed() < 0.01:
			_ctx.host.velocity = Vector3.ZERO

func _apply_friction(friction: float) -> void:
	_ctx.host.velocity.x = move_toward(_ctx.host.velocity.x, 0, friction)
	_ctx.host.velocity.z = move_toward(_ctx.host.velocity.z, 0, friction)
