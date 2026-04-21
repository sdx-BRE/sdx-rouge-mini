class_name SkeletonBossBootstrapper extends BaseSkeletonEnemyBootstrapper

func _create_attack_context() -> StateContextAttack:
	return SkeletonBossAttack.new()
