class_name MageAnimator extends RefCounted

signal die_animation_finished()

var _tree: AnimationTree
var _playback_fullbody: AnimationUtil.Playback
var _params: Params
var _conditional_queue: ConditionalQueue

var is_attacking: bool

func _init(
	tree: AnimationTree,
	playback_fullbody: AnimationUtil.Playback,
	params: Params, 
	conditional_queue: ConditionalQueue
) -> void:
	_tree = tree
	_playback_fullbody = playback_fullbody
	_params = params
	_conditional_queue = conditional_queue

func register_signals(died: Signal) -> void:
	_tree.animation_finished.connect(_on_animation_finished)
	die_animation_finished.connect(died.emit)

func request_oneshot_fire(property: StringName) -> void:
	_queue_is_attacking_flag(property)
	_tree.set(property + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func get_current_position(property: StringName) -> float:
	return _tree.get(property + "/current_position") as float

func blend_loco(value: float) -> void:
	_tree.set(_params.blend_loco, value)

func die() -> void:
	_playback_fullbody.play(_params.state_death.state_name)

func process(delta: float) -> void: _conditional_queue.process(delta)

static func create(
	tree: AnimationTree,
	param_playback_full_body: StringName,
	param_blend_loco: StringName,
	param_state_death: AnimStateMap,
) -> MageAnimator:
	var params := Params.new(param_blend_loco, param_state_death)
	var conditional_queue := ConditionalQueue.new()
	var playback_full_body := AnimationUtil.Playback.from_param(tree, param_playback_full_body)
	
	return MageAnimator.new(tree, playback_full_body, params, conditional_queue)

func _queue_is_attacking_flag(property: StringName) -> void:
	is_attacking = true
	_conditional_queue.queue(
		CQueue,
		CQueue.IsAttacking,
		ConditionalQueue.Task.when_started(func(_d) -> bool: return not _is_oneshot_active(property)),
		func(_d) -> void: is_attacking = false
	)

func _is_oneshot_active(property: StringName) -> bool:
	return _tree.get(property + "/active") as bool

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
	
	func _init(blend_l: StringName, state_d: AnimStateMap):
		blend_loco = blend_l
		state_death = state_d
