class_name EnemyAnimation extends RefCounted

var _animator: EnemyAnimator
var _params: AnimationTreeParameter

func _init(
	animator: EnemyAnimator,
	params: AnimationTreeParameter,
) -> void:
	_animator = animator
	_params = params

static func from_tree(
	tree: AnimationTree,
	params: AnimationTreeParameter,
) -> EnemyAnimation:
	var animator := EnemyAnimator.new(tree)
	animator.add_playback_from_param(EnemyAnimator.StatePlayback.FullBody, params.playback_full_body)
	
	return EnemyAnimation.new(animator, params)

func hit_weak() -> void:
	_animator.oneshot_fire(_params.oneshot_hit_weak)

func hit_strong() -> void:
	_animator.oneshot_fire(_params.oneshot_hit_strong)

func die() -> void:
	_animator.playback_travel(_params.state_death, EnemyAnimator.StatePlayback.FullBody)

func blend_loco_move(value: float) -> void:
	_animator.set_param(_params.locomotion_blend, value)

func blend_loco_timescale(value: float) -> void:
	_animator.set_param(_params.locomotion_timescale, value)

func get_animator() -> EnemyAnimator:
	return _animator
