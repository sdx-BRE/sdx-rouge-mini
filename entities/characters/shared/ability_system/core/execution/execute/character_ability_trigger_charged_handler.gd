class_name CharacterAbilityTriggerChargedHandler extends CharacterAbilityTriggerHandler

func start() -> void:
	_effect.execute(_exec.blackboard.aiming_result)
	_exec.finish()
