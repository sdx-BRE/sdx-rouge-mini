class_name SkeletonMinionStateMachineTargetHandler extends RefCounted

var _host: CharacterBody3D
var _targets_in_range: Array[Node3D]
var _target: Node3D

func _init(host: CharacterBody3D) -> void:
	_host = host

func add_target(target: Node3D) -> void:
	if not _targets_in_range.has(target):
		_targets_in_range.append(target)

func remove_target(target: Node3D) -> void:
	if _targets_in_range.has(target):
		_targets_in_range.erase(target)

func update_target() -> void:
	for target in _targets_in_range:
		if AiUtil.is_visible(target, _host, _host.fov_threshold):
			_target = target
			return
	
	_target = null

func has_target() -> bool:
	return _target != null

func is_target_in_range() -> bool:
	if _target == null:
		return false
	
	var distance_sqrd := _host.global_position.distance_squared_to(_target.global_position)
	var attack_range_sqrd :=  SkeletonMinionStateMachine.ATTACK_RANGE * SkeletonMinionStateMachine.ATTACK_RANGE
	
	return distance_sqrd <= attack_range_sqrd

func get_target_position() -> Vector3:
	if _target != null:
		return _target.global_position
	
	return Vector3.ZERO
