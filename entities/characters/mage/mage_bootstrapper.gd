class_name MageBootstrapper extends RefCounted

static func bootstrap(
	mage: MageCharacter,
	signals: MageSignals,
) -> void:
	var movement_context := _create_movement_context(mage)
	var motor := MageMotor.new(movement_context)
	
	MageBootstrapper._bootstrap_stats(mage, signals)
	MageBootstrapper._bootstrap_anim(mage, signals)
	MageBootstrapper._bootstrap_abilities(mage, movement_context, motor, signals)
	MageBootstrapper._bootstrap_processor(mage, movement_context, motor)

static func _bootstrap_stats(mage: MageCharacter, signals: MageSignals) -> void:
	var stats := mage.data.to_stats()
	var debuffs := EntityDebuffs.new()
	mage._status_manager = EntityStatusManager.new(stats, debuffs, mage.target_point)
	
	mage._status_manager.health_changed.connect(signals.health_changed.emit)
	mage._status_manager.mana_changed.connect(signals.mana_changed.emit)
	mage._status_manager.stamina_changed.connect(signals.stamina_changed.emit)
	mage._status_manager.health_reached_zero.connect(mage._on_dying)

static func _bootstrap_anim(mage: MageCharacter, signals: MageSignals) -> void:
	mage._anim = MageAnimator.create(
		mage.anim_tree,
		mage.param_playback_full_body,
		mage.param_blend_locomotion,
		mage.param_state_death,
		mage.oneshot_hit_weak,
		mage.oneshot_hit_strong,
	)
	mage._anim.register_signals(signals.died)

static func _bootstrap_abilities(
	mage: MageCharacter, 
	movement_context: MageMovementContext, 
	motor: MageMotor,
	mage_signals: MageSignals,
) -> void:
	var cooldown_manager := CooldownManager.new()
	cooldown_manager.cooldown_started.connect(mage_signals.skill_cooldown.emit)
	
	var registry := AbilityRegistry.new()
	for ability_data in mage.abilities:
		registry.register(ability_data, mage._status_manager.get_stats(), cooldown_manager)
	
	var controller := MageController.new(movement_context)
	
	var aiming_strategy := MageAbilityAimingStrategy.new(
		mage.camera_node,
		mage.ground_target_marker,
		mage.enemy_target_marker,
		mage.get_viewport(),
		mage.get_world_3d(),
	)
	var target_context := AbilityAimingContext.new(aiming_strategy)
	
	var setup_strategy := MageAbilitySetupStrategy.new(
		mage.anim_tree,
		mage_signals.casting_started,
		mage_signals.casting_progressed,
		mage_signals.casting_end,
	)
	var setup_context := AbilitySetupContext.new(setup_strategy)
	
	var execute_strategy := MageAbilityExecuteStrategy.create(
		mage,
		mage.pivot,
		mage.buff_anchor,
		mage.wandspawn_node,
		controller,
	)
	var execute_context := AbilityExecuteContext.new(execute_strategy)
	
	var recover_strategy := MageAbilityRecoverStrategy.new(mage.anim_tree)
	var recover_context := AbilityRecoverContext.new(recover_strategy)
	
	var factory := AbilityExecutionFactory.new(target_context, setup_context, execute_context, recover_context)
	var blackboard := AbilityExecutionBlackboard.new()
	
	var execution := AbilityExecuter.new(blackboard, factory)
	var manager := AbilityManager.new(execution)
	
	mage._ability_system = AbilitySystem.new(registry, manager, cooldown_manager)
	
	var use_jump_ability := func():
		mage._ability_system.use_ability_resources(AbilityId.JUMP)
		mage._ability_system.start_ability_cooldown(AbilityId.JUMP)
	
	motor.jumped.connect(use_jump_ability)
	motor.add_jump_gate(func() -> bool: return mage._ability_system.has_ability_resources(AbilityId.JUMP))

static func _bootstrap_processor(mage: MageCharacter, movement_context: MageMovementContext, motor: MageMotor) -> void:
	var processor := EntityProcessor.new(mage.get_viewport())
	var kinematics := MageKinematics.new(movement_context)
	
	_bootstrap_process_handler(processor, mage, movement_context)
	_bootstrap_physic_process_handler(processor, movement_context, kinematics, motor, mage._anim)
	_bootstrap_input_handler(processor, kinematics, mage._ability_system)
	
	mage._processor = processor

static func _bootstrap_process_handler(
	processor: EntityProcessor,
	mage: MageCharacter,
	movement_context: MageMovementContext,
) -> void:
	processor.add_process_handler(EntityStatusProcessHandler.new(mage._status_manager))
	processor.add_process_handler(MageResourceGenerator.from_data(mage._status_manager.get_stats(), mage.data))
	processor.add_process_handler(MageProcessHandler.new(mage._anim, mage._ability_system))
	
	var airbourne_observer := ObserverAirbourne.new(mage)
	airbourne_observer.subscribe_ground(MageOnGroundSubscriber.new(mage._anim, movement_context, mage.animation_jump_land))
	processor.add_process_handler(airbourne_observer)
	
	processor.add_process_handler(EnemyTargetMarkerOscillator.new(mage.enemy_target_marker))

static func _bootstrap_physic_process_handler(
	processor: EntityProcessor,
	movement_context: MageMovementContext,
	kinematics: MageKinematics,
	motor: MageMotor,
	anim: MageAnimator,
) -> void:
	processor.add_physics_handler(MageSensors.new(movement_context))
	processor.add_physics_handler(MageVelocityHandler.new(kinematics, motor))
	processor.add_physics_handler(MageBlendHandler.new(kinematics, anim))
	processor.add_physics_handler(MageCollisionsHandler.new(kinematics))

static func _bootstrap_input_handler(
	processor: EntityProcessor,
	kinematics: MageKinematics,
	ability_system: AbilitySystem,
) -> void:
	processor.add_input_handler(MageInputHandler.new(ability_system, kinematics))

static func _create_movement_context(mage: MageCharacter) -> MageMovementContext:
	var movement_config := MageMovementConfig.from_mage(mage)
	var movement_motion := MageMovementMotion.from_mage(mage)
	
	return MageMovementContext.new(mage, movement_config, movement_motion)
