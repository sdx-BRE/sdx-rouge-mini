class_name SkeletonIceMageAttack extends StateContextAttack

var _abilities: AbilitySystem

func _init(abilities: AbilitySystem) -> void:
	_abilities = abilities

func try_attack(context: StateContext) -> void:
	context.rotate_to_target()
	if context.can_attack():
		if _abilities.has_cooldown(AbilityId.SIMPLE_DEV_AOE):
			_abilities.try_activate_ability(AbilityId.FROST_BOLT)
		else:
			_abilities.try_activate_ability(AbilityId.SIMPLE_DEV_AOE)
		
		context.start_attack_cooldown()
