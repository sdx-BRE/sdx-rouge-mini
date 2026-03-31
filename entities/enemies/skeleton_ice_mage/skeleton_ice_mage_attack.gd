class_name SkeletonIceMageAttack extends StateContextAttack

func try_attack(context: StateContext) -> void:
	if context.can_attack():
		print("bats ins gesicht hinein wenn: ", context.can_attack())
		context.start_attack_cooldown()
