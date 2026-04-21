class_name EnemyAnimation extends RefCounted

var _animator: EnemyAnimator
var _params: AnimationTreeParameter
var _hit_cooldown: float = 0.0
var _hit_weak_cooldown: float
var _hit_strong_cooldown: float

func _init(
	animator: EnemyAnimator,
	params: AnimationTreeParameter,
	hit_weak_cooldown: float,
	hit_strong_cooldown: float,
) -> void:
	_animator = animator
	_params = params
	_hit_weak_cooldown = hit_weak_cooldown
	_hit_strong_cooldown = hit_strong_cooldown

static func from_tree(
	tree: AnimationTree,
	params: AnimationTreeParameter,
	hit_weak_cooldown: float,
	hit_strong_cooldown: float,
) -> EnemyAnimation:
	var animator := EnemyAnimator.new(tree)
	animator.add_playback_from_param(EnemyAnimator.StatePlayback.FullBody, params.playback_full_body)
	
	return EnemyAnimation.new(animator, params, hit_weak_cooldown, hit_strong_cooldown)

func hit_weak() -> void:
	if _hit_cooldown > 0.0:
		return
	_animator.oneshot_fire(_params.oneshot_hit_weak)
	_hit_cooldown = _hit_weak_cooldown

func hit_strong() -> void:
	if _hit_cooldown > 0.0:
		return
	_animator.oneshot_fire(_params.oneshot_hit_strong)
	_hit_cooldown = _hit_strong_cooldown

func tick(delta: float) -> void:
	_hit_cooldown -= delta

func die() -> void:
	_animator.playback_travel(_params.state_death, EnemyAnimator.StatePlayback.FullBody)

func blend_loco_move(value: float) -> void:
	_animator.set_param(_params.locomotion_blend, value)

func blend_loco_timescale(value: float) -> void:
	_animator.set_param(_params.locomotion_timescale, value)

func get_animator() -> EnemyAnimator:
	return _animator
