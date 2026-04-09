class_name SkeletonIceMageAnimator extends RefCounted

var _animator: EnemyAnimator
var _params: SkeletonIceMageAnimationParams

func _init(animator: EnemyAnimator, params: SkeletonIceMageAnimationParams) -> void:
	_animator = animator
	_params = params

func blend_loco_timescale(value: float) -> void:
	_animator.set_param(_params.loco_time_scale, value)

func blend_loco_move(value: float) -> void:
	_animator.set_param(_params.loco_blend_position, value)

func hit_strong() -> void:
	_animator.oneshot_fire(_params.oneshot_hit_strong)

func hit_weak() -> void:
	_animator.oneshot_fire(_params.oneshot_hit_weak)

func die() -> void:
	_animator.playback_travel(_params.state_death, EnemyAnimator.StatePlayback.FullBody)

