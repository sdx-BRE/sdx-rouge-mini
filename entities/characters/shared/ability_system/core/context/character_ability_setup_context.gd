class_name CharacterAbilitySetupContext extends RefCounted

var _anim_tree: AnimationTree
var _anim_started: Signal
var _anim_progressed: Signal
var _anim_end: Signal

func _init(
	anim_tree: AnimationTree,
	anim_started: Signal,
	anim_progressed: Signal,
	anim_end: Signal,
) -> void:
	_anim_tree = anim_tree
	_anim_started = anim_started
	_anim_progressed = anim_progressed
	_anim_end = anim_end

func get_animation_position(data: CharacterAbilityWindupOneshotAnimation) -> float:
	var value = _anim_tree.get(data.anim_trigger + "/current_position")
	
	return 0.0 if value == null else value

func update_cast_point(data: CharacterAbilityWindupOneshotAnimation) -> void:
	data.update_cast_point(_anim_tree)

func animate(data: CharacterAbilityWindupOneshotAnimation) -> void:
	_anim_tree.set(data.anim_trigger + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func cancel_animation(data: CharacterAbilityWindupOneshotAnimation, fadeout: bool = true) -> void:
	var oneshot_signal := AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT if fadeout \
		else AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	_anim_tree.set(data.anim_trigger + "/request", oneshot_signal)

func notify_casting_started() -> void:
	_anim_started.emit()

func notify_casting_progressed(current: float, total: float) -> void:
	_anim_progressed.emit(current, total)

func notify_casting_end() -> void:
	_anim_end.emit()
