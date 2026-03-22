class_name AnimationUtil extends RefCounted

enum Play {
	Travel,
	Start,
}

static func try_get_call_method_track_time(
	player: AnimationPlayer, 
	anim_name: StringName, 
	call_method_track_name: StringName,
):
	var animation = player.get_animation(anim_name)
	
	if animation == null:
		push_error("[AnimationUtil::try_get_call_method_track_time()] - animation not found")
		return null
	
	for track_idx in animation.get_track_count():
		if animation.track_get_type(track_idx) == Animation.TYPE_METHOD:
			for key_idx in animation.track_get_key_count(track_idx):
				var method = animation.track_get_key_value(track_idx, key_idx)
				
				if method["method"] == call_method_track_name:
					return animation.track_get_key_time(track_idx, key_idx)
	
	return null


class Playback:
	var _playback: AnimationNodeStateMachinePlayback
	
	func _init(playback: AnimationNodeStateMachinePlayback) -> void:
		_playback = playback
	
	func play(to_node: StringName, mode: AnimationUtil.Play = AnimationUtil.Play.Travel):
		match mode:
			Play.Travel:
				_playback.travel(to_node)
			Play.Start:
				_playback.start(to_node)
	
	func get_current_node() -> StringName:
		return _playback.get_current_node()
	
	func get_current_play_position() -> float:
		return _playback.get_current_play_position()
