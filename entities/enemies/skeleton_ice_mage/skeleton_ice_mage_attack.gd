class_name SkeletonIceMageAttack extends StateContextAttack

var _abilities: CharacterAbilitySystem

func _init(abilities: CharacterAbilitySystem) -> void:
	_abilities = abilities

func try_attack(context: StateContext) -> void:
	context.rotate_to_target()
	if context.can_attack():
		_abilities.try_activate_ability(CharacterAbilityId.DBG)
		context.start_attack_cooldown()
