class_name StateContext extends RefCounted

var _target_handler: AiTargetHandler
var _controller: EnemyController
var _data: EnemyData
var _stats: EnemyStats
var _attack: StateContextAttack

func _init(
	target_handler: AiTargetHandler,
	controller: EnemyController,
	data: EnemyData,
	stats: EnemyStats,
	attack: StateContextAttack,
) -> void:
	_target_handler = target_handler
	_controller = controller
	_data = data
	_stats = stats
	_attack = attack

func has_target() -> bool:
	return _target_handler.has_target()

func update_target() -> void:
	_target_handler.update_target()

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
	return 3.0 #Todo: add proper wait time _data.wait_time

func next_patrol_point() -> void:
	_controller.next_patrol_point()

func stop_instant() -> void:
	return _controller.stop_instant()

func is_moving() -> bool:
	return _controller.is_moving()

func is_alive() -> bool:
	return _stats.is_alive()

func is_dead() -> bool:
	return not is_alive()
