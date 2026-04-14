class_name CharacterAbilityExecuteTriggerChargedHandler extends CharacterAbilityExecuteTriggerHandler

func start() -> void:
	_effect.execute(_exec.blackboard.aiming_result)
	_exec.finish()
