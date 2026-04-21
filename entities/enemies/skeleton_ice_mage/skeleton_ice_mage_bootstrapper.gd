class_name SkeletonIceMageBootstrapper extends BaseSkeletonEnemyBootstrapper

var _mage: SkeletonIceMage

func setup(mage: SkeletonIceMage) -> void:
	_mage = mage

func _create_execute_strategy() -> AbilityExecuteStrategy:
	return SkeletonIceMageExecuteStrategy.create(
		_mage,
		_mage.pivot,
		_mage.staff_spawn_point,
		null,
	)

func _create_attack_context() -> StateContextAttack:
	return SkeletonIceMageAttack.new(_mage._ability_system)
