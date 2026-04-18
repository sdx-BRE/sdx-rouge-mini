class_name CharacterAbilityRecoverContext extends RefCounted

var _strategy: CharacterAbilityRecoverStrategy

func _init(strategy: CharacterAbilityRecoverStrategy) -> void:
	_strategy = strategy

func fadeout_oneshot(param: StringName) -> void:
	_strategy.fadeout_oneshot(param)

