class_name EnemyAnimator extends RefCounted

var _tree: AnimationTree
var _playbacks: Dictionary[StatePlayback, AnimationNodeStateMachinePlayback]

func _init(tree: AnimationTree) -> void:
	_tree = tree

enum StatePlayback {
	FullBody
}

func add_playback(identifier: StatePlayback, playback: AnimationNodeStateMachinePlayback) -> void:
	_playbacks.set(identifier, playback)

func add_playback_from_param(
	identifier: StatePlayback,
	param: StringName,
) -> void:
	var playback = _tree.get(param)
	
	var errorMessage := "%s: playback not found in animation tree. Given param: '%s'" % [
		_log_prefix("add_playback_from_param"),
		param,
	]
	assert(playback is AnimationNodeStateMachinePlayback, errorMessage)
	
	add_playback(identifier, playback)

func playback_travel(identifier: StatePlayback, to_node: StringName) -> void:
	var playback := _get_playback(identifier)
	if playback == null:
		var kind = StatePlayback.keys()[identifier]
		var msg := "%s: playback '%s' not found. Destination: '%s'" % [_log_prefix("playback_travel"), kind, to_node]
		push_error(msg)
		return
	
	playback.travel(to_node)

func playback_start(identifier: StatePlayback, to_node: StringName) -> void:
	var playback := _get_playback(identifier)
	if playback != null:
		var kind = StatePlayback.keys()[identifier]
		var msg := "%s: playback '%s' not found" % [_log_prefix("playback_start"), kind]
		push_error(msg)
		return
	
	playback.start(to_node)

func oneshot_fire(param: StringName) -> void:
	_tree.set(param + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func set_param(param: StringName, value: Variant) -> void:
	_tree.set(param, value)

func _is_oneshot_active(param: StringName) -> bool:
	return _tree.get(param + "/active") as bool

func _get_playback(identifier: StatePlayback) -> AnimationNodeStateMachinePlayback:
	return _playbacks.get(identifier)

func _log_prefix(method: StringName) -> String:
	return "[ERROR][EnemyAnimator.%s()]" % method
