class_name SkeletonIceMageAttack extends StateContextAttack

var _abilities: CharacterAbilitySystem

func _init(abilities: CharacterAbilitySystem) -> void:
	_abilities = abilities

func try_attack(context: StateContext) -> void:
	context.rotate_to_target()
	if context.can_attack():
		#if _abilities.has_cooldown(EnemyAbilityId.SIMPLE_DEV_AOE):
		#_abilities.try_activate_ability(EnemyAbilityId.FROST_BOLT)
		_abilities.try_activate_ability(CharacterAbilityId.DBG)
	#ä	else:
		#_abilities.try_activate_ability(EnemyAbilityId.SIMPLE_DEV_AOE)
		
		context.start_attack_cooldown()
