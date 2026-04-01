class_name SkeletonIceMageAttack extends StateContextAttack

var _abilities: AbilitySystem

func _init(abilities: AbilitySystem) -> void:
	_abilities = abilities

func try_attack(context: StateContext) -> void:
	if context.can_attack():
		_abilities.try_activate_ability(AbilityId.FROST_BOLT)
		
		context.start_attack_cooldown()
