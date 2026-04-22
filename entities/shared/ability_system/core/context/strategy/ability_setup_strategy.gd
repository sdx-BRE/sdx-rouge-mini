class_name AbilitySetupStrategy extends RefCounted

signal animation_finished(anim_name: StringName)

func get_animation_position(_data: AbilityWindupCasterAnimation) -> float:
	return 0.0

func update_cast_point(_data: AbilityWindupCasterAnimation) -> void:
	pass

func oneshot(_param: StringName) -> void:
	pass

func cancel_oneshot(_param: StringName, _fadeout: bool = true) -> void:
	pass

func notify_casting_started() -> void:
	pass

func notify_casting_progressed(_current: float, _total: float) -> void:
	pass

func notify_casting_end() -> void:
	pass

func _emit_animation_finished(anim_name: StringName) -> void:
	animation_finished.emit(anim_name)
