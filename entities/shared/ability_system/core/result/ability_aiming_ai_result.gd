class_name AbilityAimingAIResult extends AbilityAimingResult

var _handler: AiTargetHandler

func _init(handler: AiTargetHandler) -> void:
	_handler = handler

func set_projectile_target(projectile: BaseProjectile, _context: AbilityExecuteContext) -> void:
	var target := _handler.get_target()
	if target is DamageHitbox:
		projectile._target = target.entity
	else:
		projectile._target = target

func launch_aoe(aoe: BaseAoe, _context: AbilityExecuteContext) -> void:
	aoe.global_position = _handler.get_target_position()
