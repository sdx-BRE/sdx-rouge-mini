class_name SkeletonMinionMeleeAttack extends StateContextAttack

const PUNCH_ATTACK: StringName = &"punch"

var _abilities: AbilitySystem

func _init(abilities: AbilitySystem) -> void:
	_abilities = abilities

func try_attack(context: StateContext) -> void:
	context.rotate_to_target()
	if context.can_attack():
		_abilities.try_activate_ability(PUNCH_ATTACK)
		context.start_attack_cooldown()
