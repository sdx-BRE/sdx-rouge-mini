class_name MageAnimator extends RefCounted

var _tree: AnimationTree
var _props: Props
var _conditional_queue: ConditionalQueue

var is_attacking: bool

func request_oneshot_fire(property: StringName) -> void:
	_tree.set(property + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func get_current_position(property: StringName) -> float:
	return _tree.get(property + "/current_position") as float

func blend_loco(value: float) -> void:
	_tree.set(_props.blend_loco, value)

func _init(tree: AnimationTree, props: Props, conditional_queue: ConditionalQueue) -> void:
	_tree = tree
	_props = props
	_conditional_queue = conditional_queue

static func create(
	tree: AnimationTree,
	playback_full_body: StringName,
	param_blend_loco: StringName,
) -> MageAnimator:
	var props = Props.new(playback_full_body, param_blend_loco)
	var conditional_queue = ConditionalQueue.new()
	
	return MageAnimator.new(tree, props, conditional_queue)

func _queue_is_attacking_flag(property: StringName) -> void:
	is_attacking = true
	_conditional_queue.queue(
		CQueue,
		CQueue.IsAttacking,
		func(_d, task: ConditionalQueue.ConditionalQueueTask) -> bool:
			var is_in_attack = _is_oneshot_active(property)
			var is_started = task.data.get("started", false)
			
			if not is_started and not is_in_attack:
				task.data.set("started", true)
			
			return is_started and not is_in_attack,
		func(_d) -> void: is_attacking = false
	)

func _is_oneshot_active(property: StringName) -> bool:
	return _tree.get(property + "/active") as bool

enum CQueue {
	IsAttacking,
}

class Props:
	var playback_full_body: StringName
	var blend_loco: StringName
	
	func _init(playback_fb: StringName, blend_l: StringName):
		playback_full_body = playback_fb
		blend_loco = blend_l
