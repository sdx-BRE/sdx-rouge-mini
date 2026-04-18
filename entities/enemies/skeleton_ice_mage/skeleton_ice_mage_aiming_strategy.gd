class_name SkeletonIceMageAimingStrategy extends AbilityAimingStrategy

var _handler: AiTargetHandler

func _init(handler: AiTargetHandler) -> void:
	_handler = handler

func get_ai_target_handler() -> AiTargetHandler:
	return _handler
