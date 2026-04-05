class_name AbilityEntity extends Area3D

@export var enable_debug := false

func launch_enemy_ability(ability: EnemyCastAbility, context: EnemyAbilityContextCast) -> void:
	if enable_debug:
		var err := DbgHelper.err("AbilityEntity.launch_ability", "must be overwritten by child implementations")
		push_error(err, " - ability: ", ability, " - context: ", context)

func setup_enemy_ability(ability: EnemyCastAbility, context: EnemyAbilityContextCast) -> void:
	if enable_debug:
		var err := DbgHelper.err("AbilityEntity.setup", "must be overwritten by child implementations")
		push_error(err, " - ability: ", ability, " - context: ", context)
