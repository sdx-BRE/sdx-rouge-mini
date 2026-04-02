class_name AbilityEntity extends Area3D

func launch_ability(ability: EnemyCastAbility, context: EnemyAbilityContextCast) -> void:
	var err := DbgHelper.err("AbilityEntity.launch_ability", "must be overwritten by child implementations")
	push_error(err, " - ability: ", ability, " - context: ", context)
