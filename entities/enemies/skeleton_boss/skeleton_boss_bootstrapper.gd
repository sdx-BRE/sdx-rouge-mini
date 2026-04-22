class_name SkeletonBossBootstrapper extends BaseSkeletonEnemyBootstrapper

func _create_attack_context() -> StateContextAttack:
	return SkeletonBossAttack.new(_entity._ability_system)

func _create_execute_strategy() -> AbilityExecuteStrategy:
	return SkeletonBossExecuteStrategy.create(_entity)
