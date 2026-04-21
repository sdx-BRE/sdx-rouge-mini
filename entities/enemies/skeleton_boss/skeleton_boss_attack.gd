class_name SkeletonBossAttack extends StateContextAttack

func try_attack(context: StateContext) -> void:
	if context.can_attack():
		context.start_attack_cooldown()
		
		print("buds")
