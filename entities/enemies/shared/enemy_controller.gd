class_name EnemyController extends RefCounted

var _ctx: EnemyMovementContext
var _patrol_points: Array[Marker3D]

var _patrol_point_size: int
var _patrol_index := 0

func _init(ctx: EnemyMovementContext, patrol_points: Array[Marker3D]) -> void:
	_ctx = ctx
	
	_patrol_points = patrol_points
	_patrol_point_size = patrol_points.size()

func change_target(target: Vector3) -> void:
	if _ctx.agent.target_position != target:
		_ctx.agent.target_position = target

func is_navigation_finished() -> bool:
	return _ctx.agent.is_navigation_finished()

func run_to_target() -> void:
	_ctx.motion.speed = _ctx.config.running_speed
	_ctx.motion.is_movement_enabled = true

func walk_to_target() -> void:
	_ctx.motion.speed = _ctx.config.walking_speed
	_ctx.motion.is_movement_enabled = true

func stop_moving() -> void:
	_ctx.motion.is_movement_enabled = false

func next_patrol_point():
	if _patrol_index + 1 >= _patrol_point_size:
		_patrol_index = 0
	else:
		_patrol_index += 1
	
	_use_patrol_point_as_target()

func _use_patrol_point_as_target() -> void:
	if _patrol_point_size == 0:
		return
	var patrol_point := _patrol_points[_patrol_index]
	change_target(patrol_point.global_position)
