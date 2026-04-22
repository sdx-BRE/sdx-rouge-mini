class_name SkeletonBossAttack extends StateContextAttack

const CHOP_ATTACK: StringName = &"chop"

var _abilities: AbilitySystem

func _init(abilities: AbilitySystem) -> void:
	_abilities = abilities

func try_attack(context: StateContext) -> void:
	context.rotate_to_target()
	if context.can_attack():
		_abilities.try_activate_ability(CHOP_ATTACK)
		context.start_attack_cooldown()
