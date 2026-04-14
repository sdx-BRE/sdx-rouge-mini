class_name CharacterAbilityTriggerNormalHandler extends CharacterAbilityTriggerHandler

func start() -> void:
	_effect.execute(_exec.blackboard.aiming_result)
	_exec.finish()
