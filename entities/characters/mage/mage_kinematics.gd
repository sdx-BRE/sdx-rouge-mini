class_name MageKinematics extends RefCounted

var _host: CharacterBody3D
var _config: MageMovementConfig
var _motion: MageMovementMotion

func _init(host: CharacterBody3D, config: MageMovementConfig, motion: MageMovementMotion) -> void:
	_host = host
	_config = config
	_motion = motion

func handle_gravity(delta: float) -> void:
	if _host.is_on_floor():
		_motion.coyote_timer = _config.coyote_time
	else:
		_motion.coyote_timer -= delta
	
	var gravity := 0.0
	if _host.velocity.y > 0:
		gravity = _config.get_jump_gravity() * delta
	else:
		gravity = _config.get_fall_gravity() * delta
	
	if abs(_host.velocity.y) < _config.apex_threshold:
		gravity *= _config.apex_gravity_multiplier
	
	_host.velocity.y -= gravity

func update_velocity(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := _calculate_movement_direction(input_dir)
	
	if direction:
		_host.velocity.x = direction.x * _config.movement_speed
		_host.velocity.z = direction.z * _config.movement_speed
		_look_at(direction, delta)
		
		_host.velocity.x += _motion.dash_power.x
		_host.velocity.z += _motion.dash_power.z
	else:
		_host.velocity.x = move_toward(_host.velocity.x, 0, _config.movement_speed)
		_host.velocity.z = move_toward(_host.velocity.z, 0, _config.movement_speed)
	
	_motion.dash_power = _motion.dash_power.move_toward(Vector3.ZERO, _config.dash_decay * delta * 10)

func move_and_slide() -> void:
	_host.move_and_slide()

func get_speed_ratio() -> float:
	return get_speed() / _config.movement_speed

func get_speed() -> float:
	return Vector3(_host.velocity.x, 0, _host.velocity.z).length()

func delegate_input_to_camera(event: InputEvent):
	_config.camera_node.handle_input(event)

func _look_at(direction: Vector3, delta: float) -> void:
	var target_rotation := atan2(direction.x, direction.z)
	_host.pivot.rotation.y = lerp_angle(_host.pivot.rotation.y, target_rotation, delta * _config.look_at_weight)

func _calculate_movement_direction(input_dir: Vector2) -> Vector3:
	if _config.camera_node == null:
		return (_host.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var cam_forward := _config.camera_node.global_transform.basis.z
	cam_forward.y = 0
	cam_forward = cam_forward.normalized()
	
	var cam_right := _config.camera_node.global_transform.basis.x
	cam_right.y = 0
	cam_right = cam_right.normalized()
	
	var direction := (cam_right * input_dir.x) + (cam_forward * input_dir.y)
	if direction.length() > 0:
		direction = direction.normalized()
	
	return direction
