class_name MCharacterAbilityExecutionSetupContext extends RefCounted

var _anim_tree: AnimationTree
var _signals: CharacterAbilitySignals

func _init(
	anim_tree: AnimationTree,
	signals: CharacterAbilitySignals,
) -> void:
	_anim_tree = anim_tree
	_signals = signals

func get_animation_position(data: McharacterAbilityWindupAnimation) -> float:
	var value = _anim_tree.get(data.anim_trigger + "/current_position")
	
	return 0.0 if value == null else value

func update_cast_point(data: McharacterAbilityWindupAnimation) -> void:
	data.update_cast_point(_anim_tree)

func animate(data: McharacterAbilityWindupAnimation) -> void:
	_anim_tree.set(data.anim_trigger + "/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func cancel_animation(data: McharacterAbilityWindupAnimation, fadeout: bool = true) -> void:
	var oneshot_signal := AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT if fadeout \
		else AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	_anim_tree.set(data.anim_trigger + "/request", oneshot_signal)

func notify_casting_started() -> void:
	_signals.ability_started.emit()

func notify_casting_progressed(current: float, total: float) -> void:
	_signals.ability_progressed.emit(current, total)

func notify_casting_end() -> void:
	_signals.ability_end.emit()
