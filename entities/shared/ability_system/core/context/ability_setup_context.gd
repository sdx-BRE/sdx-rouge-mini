class_name AbilitySetupContext extends RefCounted

var _strategy: AbilitySetupStrategy

func _init(strategy: AbilitySetupStrategy) -> void:
	_strategy = strategy

func get_animation_position(data: AbilityWindupAnimation) -> float:
	return _strategy.get_animation_position(data)

func update_cast_point(data: AbilityWindupAnimation) -> void:
	_strategy.update_cast_point(data)

func oneshot(param: StringName) -> void:
	_strategy.oneshot(param)

func cancel_oneshot(param: StringName, fadeout: bool = true) -> void:
	_strategy.cancel_oneshot(param, fadeout)

func notify_casting_started() -> void:
	_strategy.notify_casting_started()

func notify_casting_progressed(current: float, total: float) -> void:
	_strategy.notify_casting_progressed(current, total)

func notify_casting_end() -> void:
	_strategy.notify_casting_end()

