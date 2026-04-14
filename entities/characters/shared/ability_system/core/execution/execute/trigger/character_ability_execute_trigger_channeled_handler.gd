class_name CharacterAbilityExecuteTriggerChanneledHandler extends CharacterAbilityExecuteTriggerHandler

func start() -> void:
	_effect.execute(_exec.blackboard.aiming_result)

func tick(_delta: float) -> void:
	_effect.execute(_exec.blackboard.aiming_result)

func release() -> void:
	_exec.finish()
