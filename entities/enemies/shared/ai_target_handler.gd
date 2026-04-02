class_name AiTargetHandler extends RefCounted

var _host: CharacterBody3D
var _attack_range: float
var _fov_threshold: float

var _targets_in_range: Array[Node3D]
var _target: Node3D

func _init(
	host: CharacterBody3D, 
	attack_range: float,
	fov_threshold: float,
) -> void:
	_host = host
	_attack_range = attack_range
	_fov_threshold = fov_threshold

func add_target(target: Node3D) -> void:
	if not _targets_in_range.has(target):
		_targets_in_range.append(target)

func remove_target(target: Node3D) -> void:
	if _targets_in_range.has(target):
		_targets_in_range.erase(target)

func update_target() -> void:
	for target in _targets_in_range:
		if AiTargetHandler.is_visible(target, _host, _fov_threshold):
			_target = target
			return
	
	_target = null

func has_target() -> bool:
	return _target != null

func update_and_has_target() -> bool:
	update_target()
	return has_target()

func is_target_in_range() -> bool:
	if _target == null:
		return false
	
	var distance_sqrd := _host.global_position.distance_squared_to(_target.global_position)
	var attack_range_sqrd :=  _attack_range * _attack_range
	
	return distance_sqrd <= attack_range_sqrd

func get_target() -> Node3D:
	return _target

func get_target_position() -> Vector3:
	if _target != null:
		return _target.global_position
	
	return Vector3.ZERO

static func is_visible(target: Node3D, source: Node3D, fov_threshold: float) -> bool:
	var direction := (target.global_position
		- source.global_position).normalized()
	var dot := -source.global_transform.basis.z.dot(direction)
	
	return dot >= fov_threshold
