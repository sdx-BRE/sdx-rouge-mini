class_name CharacterAbilityAimingAIResult extends CharacterAbilityAimingResult

var _handler: AiTargetHandler

func _init(handler: AiTargetHandler) -> void:
	_handler = handler

func set_projectile_target(projectile: BaseProjectile, _context: CharacterAbilityExecuteContext) -> void:
	var target := _handler.get_target()
	if target is DamageHitbox:
		projectile._target = target.entity
	else:
		projectile._target = target

func set_aoe_position(aoe: BaseAoe, _context: CharacterAbilityExecuteContext) -> void:
	aoe.global_position = _handler.get_target_position()
