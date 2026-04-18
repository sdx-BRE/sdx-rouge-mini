class_name SkeletonIceMageBootstrapper extends BaseSkeletonEnemyBootstrapper

var _mage: SkeletonIceMage

func setup(mage: SkeletonIceMage) -> void:
	_mage = mage

func _boot_processor() -> void:
	_bootstrap_ability_system()
	super ()

func _create_attack_context() -> StateContextAttack:
	return SkeletonIceMageAttack.new(_mage._ability_system)

func _boot_processor_process_handler() -> void:
	_mage._processor.add_process_handler(EnemyAbilitySystemHandler.new(_mage._ability_system))

func _bootstrap_ability_system() -> void:
	var registry := CharacterAbilityRegistry.new()
	var cooldown_manager := CooldownManager.new()
	
	registry.register(_mage.dev_ability, _mage._stats, cooldown_manager)
	
	var aiming_strategy := SkeletonIceMageAimingStrategy.new(_mage._target_handler)
	var target_context := CharacterAbilityAimingContext.new(aiming_strategy)
	
	var setup_strategy := SkeletonIceMageSetupStrategy.new(_mage.anim_tree)
	var setup_context := CharacterAbilitySetupContext.new(setup_strategy)
	
	var execute_strategy := SkeletonIceMageExecuteStrategy.create(
		_mage,
		_mage.pivot,
		_mage.staff_spawn_point,
		null, # AI controller placeholder
	)
	var execute_context := CharacterAbilityExecuteContext.new(execute_strategy)
	
	var recover_strategy := SkeletonIceMageRecoverStrategy.new(_mage.anim_tree)
	var recover_context := CharacterAbilityRecoverContext.new(recover_strategy)
	
	var factory := CharacterAbilityExecutionFactory.new(target_context, setup_context, execute_context, recover_context)
	var blackboard := CharacterAbilityExecutionBlackboard.new()
	var execution := CharacterAbilityExecuter.new(blackboard, factory)
	var manager := CharacterAbilityManager.new(execution)
	
	_mage._ability_system = CharacterAbilitySystem.new(registry, manager, cooldown_manager)
