class_name SkeletonMinionController extends RefCounted

var _host: CharacterBody3D
var _agent: NavigationAgent3D
var _patrol_points: Array[Marker3D]

var _patrol_point_size: int
var _patrol_index := 0

func _init(
	host: CharacterBody3D,
	agent: NavigationAgent3D,
	patrol_points: Array[Marker3D],
) -> void:
	_host = host
	_agent = agent
	_patrol_points = patrol_points
	_patrol_point_size = patrol_points.size()

func move_and_slide() -> void:
	_host.move_and_slide()

func navigate_to_target(speed: float, delta: float) -> void:
	var next_pos := _agent.get_next_path_position()
	var direction := (next_pos - _host.global_position)
	
	direction.y = 0.0
	direction = direction.normalized()
	
	if not direction.is_zero_approx():
		_look_at(direction, delta)
	
	var desired_velocity := direction * speed
	_agent.set_velocity(desired_velocity)
	_host.velocity = _agent.get_velocity()

func change_target(target: Vector3) -> void:
	_agent.target_position = target

func apply_friction(friction: float) -> void:
	_host.velocity.x = move_toward(_host.velocity.x, 0, friction)
	_host.velocity.z = move_toward(_host.velocity.z, 0, friction)

func stop_instant() -> void:
	_host.velocity = Vector3.ZERO

func apply_friction_if_moving(friction: float) -> void:
	if _host.velocity.length() > 0:
		apply_friction(friction)

func next_patrol_point():
	if _patrol_index + 1 >= _patrol_point_size:
		_patrol_index = 0
	else:
		_patrol_index += 1
	
	_use_patrol_point_as_target()

func is_navigation_finished() -> bool:
	return _agent.is_navigation_finished()

func is_moving() -> bool:
	return _host.velocity.length() > 0

func get_horizontal_speed() -> float:
	return Vector3(_host.velocity.x, 0, _host.velocity.z).length()

func handle_gravity(delta: float) -> void:
	if not _host.is_on_floor():
		_host.velocity += _host.get_gravity() * delta

func _look_at(direction: Vector3, delta: float) -> void:
	var target_rotation := atan2(-direction.x, -direction.z)
	_host.rotation.y = lerp_angle(_host.rotation.y, target_rotation, delta * 10.0)

func _use_patrol_point_as_target() -> void:
	if _patrol_point_size == 0:
		return
	var patrol_point := _patrol_points[_patrol_index]
	change_target(patrol_point.global_position)
