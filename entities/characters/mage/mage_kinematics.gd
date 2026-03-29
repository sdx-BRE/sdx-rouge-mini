class_name MageKinematics extends RefCounted

const ACCELERATION := 70.0

var _ctx: MageMovementContext
var _current_speed: float = 0.0

func _init(context: MageMovementContext) -> void:
	_ctx = context

func handle_gravity(delta: float) -> void:
	var gravity := 0.0
	if _ctx.host.velocity.y > 0:
		gravity = _ctx.config.get_jump_gravity() * delta
	else:
		gravity = _ctx.config.get_fall_gravity() * delta
	
	if abs(_ctx.host.velocity.y) < _ctx.config.apex_threshold:
		gravity *= _ctx.config.apex_gravity_multiplier
	
	_ctx.host.velocity.y -= gravity

func update_velocity(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := _calculate_movement_direction(input_dir)
	
	if direction:
		_current_speed = move_toward(_current_speed, _ctx.motion.target_speed, ACCELERATION * delta)
		
		_ctx.host.velocity.x = direction.x * _current_speed
		_ctx.host.velocity.z = direction.z * _current_speed
		_look_at(direction, delta)
		
		_ctx.host.velocity.x += _ctx.motion.dash_power.x
		_ctx.host.velocity.z += _ctx.motion.dash_power.z
	else:
		_current_speed = move_toward(_current_speed, 0, ACCELERATION * delta)
		
		_ctx.host.velocity.x = move_toward(_ctx.host.velocity.x, 0, _ctx.motion.target_speed)
		_ctx.host.velocity.z = move_toward(_ctx.host.velocity.z, 0, _ctx.motion.target_speed)
	
	_ctx.motion.dash_power = _ctx.motion.dash_power.move_toward(Vector3.ZERO, _ctx.config.dash_decay * delta * 10)

func move_and_slide() -> void:
	_ctx.host.move_and_slide()

func get_speed_ratio() -> float:
	return get_speed() / _ctx.motion.target_speed

func get_speed() -> float:
	return Vector3(_ctx.host.velocity.x, 0, _ctx.host.velocity.z).length()

func delegate_input_to_camera(event: InputEvent):
	_ctx.config.camera_node.handle_input(event)

func _look_at(direction: Vector3, delta: float) -> void:
	var target_rotation := atan2(direction.x, direction.z)
	_ctx.host.pivot.rotation.y = lerp_angle(_ctx.host.pivot.rotation.y, target_rotation, delta * _ctx.config.look_at_weight)

func _calculate_movement_direction(input_dir: Vector2) -> Vector3:
	if _ctx.config.camera_node == null:
		return (_ctx.host.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var cam_forward := _ctx.config.camera_node.global_transform.basis.z
	cam_forward.y = 0
	cam_forward = cam_forward.normalized()
	
	var cam_right := _ctx.config.camera_node.global_transform.basis.x
	cam_right.y = 0
	cam_right = cam_right.normalized()
	
	var direction := (cam_right * input_dir.x) + (cam_forward * input_dir.y)
	if direction.length() > 0:
		direction = direction.normalized()
	
	return direction
