class_name SkeletonIceMageBootstrapper extends BaseSkeletonEnemyBootstrapper

var _mage: SkeletonIceMage

func setup(mage: SkeletonIceMage) -> void:
	_mage = mage

func _boot_processor() -> void:
	_bootstrap_ability_system()
	super()

func _create_attack_context() -> StateContextAttack:
	return SkeletonIceMageAttack.new(_mage._ability_system)

func _boot_processor_process_handler() -> void:
	_mage._processor.add_process_handler(EnemyAbilitySystemHandler.new(_mage._ability_system))

func _bootstrap_ability_system() -> void:
	var registry := EnemyAbilityRegistry.new()
	registry.add_ability(EnemyAbilityId.FROST_BOLT, _mage.frost_bolt)
	registry.add_ability(EnemyAbilityId.SIMPLE_DEV_AOE, _mage.ground_aoe)
	
	var cast_context := EnemyAbilityContextCast.create(
		_mage._stats,
		_mage,
		_mage.pivot,
		_mage._anim.get_animator(),
		_mage._target_handler,
		_mage.staff_spawn_point
	)
	
	var cooldown_manager := CooldownManager.new()
	var resolver := EnemyAbilityResolver.new(
		EnemyAbilityHandlerCast.new(cast_context, cooldown_manager),
		EnemyAbilityHandlerInstant.new(),
	)
	
	_mage._ability_system =  EnemyAbilitySystem.new(registry, resolver, cooldown_manager)
