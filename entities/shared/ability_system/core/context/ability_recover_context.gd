class_name AbilityRecoverContext extends RefCounted

var _strategy: AbilityRecoverStrategy

func _init(strategy: AbilityRecoverStrategy) -> void:
	_strategy = strategy

func fadeout_oneshot(param: StringName) -> void:
	_strategy.fadeout_oneshot(param)

