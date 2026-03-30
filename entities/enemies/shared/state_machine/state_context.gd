class_name StateContext extends RefCounted

var _target_handler: AiTargetHandler
var _controller: EnemyController
var _blackboard: EnemyBlackboard
var _data: EnemyData
var _stats: EnemyStats
var _attack: StateContextAttack

func _init(
	target_handler: AiTargetHandler,
	controller: EnemyController,
	blackboard: EnemyBlackboard,
	data: EnemyData,
	stats: EnemyStats,
	attack: StateContextAttack,
) -> void:
	_target_handler = target_handler
	_controller = controller
	_blackboard = blackboard
	_data = data
	_stats = stats
	_attack = attack

func tick(delta: float) -> void:
	_blackboard.tick(delta)

func has_target() -> bool:
	return _target_handler.has_target()

func is_target_in_range() -> bool:
	return _target_handler.is_target_in_range()

func try_attack() -> void:
	_attack.try_attack(self)

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

func is_navigation_finished() -> bool:
	return _controller.is_navigation_finished()

func get_wait_time() -> float:
	return _data.wait_time

func next_patrol_point() -> void:
	_controller.next_patrol_point()

func can_attack() -> bool:
	return _blackboard.can_attack()

func start_attack_cooldown() -> void:
	_blackboard.start_attack_cooldown(_data.attack_cooldown)
