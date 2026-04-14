class_name CharacterAbilityExecuteTriggerChanneledHandler extends CharacterAbilityExecuteTriggerHandler

func start() -> void:
	if _exec.blackboard.is_released:
		_exec.finish()
		return
	_delivery.execute(_exec.blackboard.aiming_result)

func tick(_delta: float) -> void:
	if _exec.blackboard.is_released:
		_exec.finish()
		return
	_delivery.execute(_exec.blackboard.aiming_result)

func release() -> void:
	_exec.finish()
