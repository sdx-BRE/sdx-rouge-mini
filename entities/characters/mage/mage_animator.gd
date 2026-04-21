class_name MageAnimator extends RefCounted

signal die_animation_finished()

var _tree: AnimationTree
var _playback_fullbody: AnimationUtil.Playback
var _params: Params
var _conditional_queue: ConditionalQueue
var _hit_cooldown: float = 0.0
var _hit_weak_cooldown: float
var _hit_strong_cooldown: float

func _init(
	tree: AnimationTree,
	playback_fullbody: AnimationUtil.Playback,
	params: Params, 
	conditional_queue: ConditionalQueue,
	hit_weak_cooldown: float,
	hit_strong_cooldown: float,
) -> void:
	_tree = tree
	_playback_fullbody = playback_fullbody
	_params = params
	_conditional_queue = conditional_queue
	_hit_weak_cooldown = hit_weak_cooldown
	_hit_strong_cooldown = hit_strong_cooldown

func register_signals(died: Signal) -> void:
	_tree.animation_finished.connect(_on_animation_finished)
	die_animation_finished.connect(died.emit)

func request_oneshot_fire(property: StringName) -> void:
	_tree.set(property + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func get_current_position(property: StringName) -> float:
	return _tree.get(property + "/current_position") as float

func play_full_body(to_node: StringName, mode: AnimationUtil.Play = AnimationUtil.Play.Travel) -> void:
	_playback_fullbody.play(to_node, mode)

func blend_loco(value: float) -> void:
	_tree.set(_params.blend_loco, value)

func die() -> void:
	_playback_fullbody.play(_params.state_death.state_name)

func hit_weak() -> void:
	if _hit_cooldown > 0.0:
		return
	request_oneshot_fire(_params.oneshot_hit_weak)
	_hit_cooldown = _hit_weak_cooldown

func hit_strong() -> void:
	if _hit_cooldown > 0.0:
		return
	request_oneshot_fire(_params.oneshot_hit_strong)
	_hit_cooldown = _hit_strong_cooldown

func process(delta: float) -> void: 
	_hit_cooldown -= delta
	_conditional_queue.process(delta)

static func create(
	tree: AnimationTree,
	param_playback_full_body: StringName,
	param_blend_loco: StringName,
	param_state_death: AnimStateMap,
	param_oneshot_hit_weak,
	param_oneshot_hit_strong,
	hit_weak_cooldown: float,
	hit_strong_cooldown: float,
) -> MageAnimator:
	var params := Params.new(param_blend_loco, param_state_death, param_oneshot_hit_weak, param_oneshot_hit_strong)
	var conditional_queue := ConditionalQueue.new()
	var playback_full_body := AnimationUtil.Playback.from_param(tree, param_playback_full_body)
	
	return MageAnimator.new(tree, playback_full_body, params, conditional_queue, hit_weak_cooldown, hit_strong_cooldown)

func _on_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		_params.state_death.anim_name: die_animation_finished.emit()

enum CQueue {
	IsAttacking,
	IsDying,
}

class Params:
	var blend_loco: StringName
	var state_death: AnimStateMap
	var oneshot_hit_weak: StringName
	var oneshot_hit_strong: StringName
	
	func _init(blend_l: StringName, state_d: AnimStateMap, os_hit_weak: StringName, os_hit_strong: StringName):
		blend_loco = blend_l
		state_death = state_d
		oneshot_hit_weak = os_hit_weak
		oneshot_hit_strong = os_hit_strong
