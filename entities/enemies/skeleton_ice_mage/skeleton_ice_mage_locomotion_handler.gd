class_name SkeletonIceMageLocomotionHandler extends PhysicsProcessHandler

const BASE_TIMESCALE := 1.0
const MAX_TIMESCALE := 1.8

var _kinematics: EnemyKinematics
var _anim: SkeletonIceMageAnimator
var _walk_speed: float
var _run_speed: float

var _movement_blend := 0.0
var _movement_timescale := 1.0

func _init(
	kinematics: EnemyKinematics,
	anim: SkeletonIceMageAnimator,
	walk_speed: float,
	run_speed: float,
):
	_kinematics = kinematics
	_anim = anim
	_walk_speed = walk_speed
	_run_speed = run_speed

func physics_process(delta: float) -> void:
	var speed := _kinematics.get_horizontal_speed()
	
	var run_to_walk_ratio = clamp(
		(speed - _walk_speed) / (_run_speed - _walk_speed),
		0,
		1
	)
	var movement_timescale = lerp(BASE_TIMESCALE, MAX_TIMESCALE, run_to_walk_ratio)
	var movement_blend := speed / _walk_speed
	
	_movement_timescale = lerp(_movement_timescale, movement_timescale, delta * 10)
	_movement_blend = lerp(_movement_blend, movement_blend, delta * 10)
	
	_anim.blend_loco_timescale(_movement_timescale)
	_anim.blend_loco_move(_movement_blend)
