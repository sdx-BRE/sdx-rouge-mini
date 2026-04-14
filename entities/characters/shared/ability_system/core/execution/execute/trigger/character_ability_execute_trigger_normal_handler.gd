class_name CharacterAbilityExecuteTriggerNormalHandler extends CharacterAbilityExecuteTriggerHandler

func start() -> void:
	_delivery.execute(_exec.blackboard.aiming_result)
	_exec.finish()
