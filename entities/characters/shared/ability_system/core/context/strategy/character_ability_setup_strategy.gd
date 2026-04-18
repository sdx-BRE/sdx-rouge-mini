class_name CharacterAbilitySetupStrategy extends RefCounted

func get_animation_position(_data: CharacterAbilityWindupAnimation) -> float:
	return 0.0

func update_cast_point(_data: CharacterAbilityWindupAnimation) -> void:
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
