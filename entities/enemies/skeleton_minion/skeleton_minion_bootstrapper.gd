class_name SkeletonMinionBootstrapper extends BaseSkeletonEnemyBootstrapper

var _minion: SkeletonMinion

func setup(minion: SkeletonMinion) -> void:
	_minion = minion

func _create_execute_strategy() -> AbilityExecuteStrategy:
	return SkeletonMinionExecuteStrategy.new(
		_entity._anim.get_animator(),
		&"parameters/PunchOneShot",
	)

func _create_attack_context() -> StateContextAttack:
	return SkeletonMinionMeleeAttack.new(_entity._ability_system)

func _wire_signals() -> void:
	super()
	_minion.punch_hitbox.area_entered.connect(_minion._on_punch)
