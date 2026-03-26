class_name SkeletonMinionStateContext extends RefCounted

var _controller: SkeletonMinionController
var _target_handler: SkeletonMinionStateMachineTargetHandler
var _anim: SkeletonMinionAnimator
var _data: SkeletonMinionStateData
var _config: SkeletonMinionStateConfig

func _init(
	controller: SkeletonMinionController,
	target_handler: SkeletonMinionStateMachineTargetHandler,
	anim: SkeletonMinionAnimator,
	data: SkeletonMinionStateData,
	config: SkeletonMinionStateConfig,
) -> void:
	_controller = controller
	_target_handler = target_handler
	_anim = anim
	_data = data
	_config = config



func has_target() -> bool:
	return _target_handler.has_target()

func update_target() -> void:
	_target_handler.update_target()

func is_target_in_range() -> bool:
	return _target_handler.is_target_in_range()

func try_attack() -> void:
	if not _anim.is_attacking and _data.attack_cooldown <= 0:
		_anim.punch_attack()
		_data.attack_cooldown = _config.attack_cooldown

func get_target_position() -> Vector3:
	return _target_handler.get_target_position()

func stop_moving() -> void:
	_controller.apply_friction_if_moving(_data.walking_speed)

func change_target(target_pos: Vector3) -> void:
	_controller.change_target(target_pos)

func run_to_target(delta: float) -> void:
	_controller.navigate_to_target(_data.running_speed, delta)

func walk_to_target(delta: float) -> void:
	_controller.navigate_to_target(_data.walking_speed, delta)

func next_patrol_point() -> void:
	_controller.next_patrol_point()

func stop_instant() -> void:
	return _controller.stop_instant()

func is_moving() -> bool:
	return _controller.is_moving()

func is_navigation_finished() -> bool:
	return _controller.is_navigation_finished()

func get_wait_time() -> float:
	return _config.wait_time

func reduce_attack_cooldown(value: float) -> void:
	_data.attack_cooldown -= value
