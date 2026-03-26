class_name SkeletonMinionStateAliveAggroAttacking extends SkeletonMinionStateBase

func process(_delta: float):
	_context.stop_moving()
	_context.try_attack()
