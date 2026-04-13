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
	mage._stats = mage.data.to_stats()
	
	mage._stats.health_changed.connect(signals.health_changed.emit)
	mage._stats.mana_changed.connect(signals.mana_changed.emit)
	mage._stats.stamina_changed.connect(signals.stamina_changed.emit)
	mage._stats.health_reached_zero.connect(mage._on_dying)

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
	
	var registry := MCharacterAbilityRegistry.new()
	for ability_data in mage.dev_abilities:
		registry.register(ability_data, mage._stats, cooldown_manager)
	
	var controller := MageController.new(movement_context)
	
	var target_context := MCharacterAbilityExecutionAimingContext.new(
		mage.camera_node,
		mage.ground_target_marker,
		mage.enemy_target_marker,
		mage.get_viewport(),
		mage.get_world_3d(),
	)
	var setup_context := MCharacterAbilityExecutionSetupContext.new(
		mage.anim_tree,
		CharacterAbilitySignals.new(mage_signals.casting_started, mage_signals.casting_progressed, mage_signals.casting_end),
	)
	var execute_context := MCharacterAbilityExecutionExecuteContext.create(
		mage,
		mage.pivot,
		mage.buff_anchor,
		mage.wandspawn_node,
		controller,
	)
	
	var factory := MCharacterAbilityExecutionFactory.new(target_context, setup_context, execute_context)
	var blackboard := MCharacterAbilityExecutionBlackboard.new()
	
	var execution := MCharacterAbilityExecution.new(blackboard, factory)
	var manager := MCharacterAbilityManager.new(execution)
	
	mage._m_ability_system = MCharacterAbilitySystem.new(registry, manager, cooldown_manager)
	
	var use_jump_ability := func():
		mage._m_ability_system.use_ability_resources(MCharacaterAbilityId.JUMP)
		mage._m_ability_system.start_ability_cooldown(MCharacaterAbilityId.JUMP)
	
	motor.jumped.connect(use_jump_ability)
	motor.add_jump_gate(func() -> bool: return mage._m_ability_system.has_ability_resources(MCharacaterAbilityId.JUMP))

static func _bootstrap_processor(mage: MageCharacter, movement_context: MageMovementContext, motor: MageMotor) -> void:
	var processor := EntityProcessor.new(mage.get_viewport())
	var kinematics := MageKinematics.new(movement_context)
	
	_bootstrap_process_handler(processor, mage, movement_context)
	_bootstrap_physic_process_handler(processor, movement_context, kinematics, motor, mage._anim)
	_bootstrap_input_handler(processor, kinematics, mage._m_ability_system)
	
	mage._processor = processor

static func _bootstrap_process_handler(
	processor: EntityProcessor,
	mage: MageCharacter,
	movement_context: MageMovementContext,
) -> void:
	processor.add_process_handler(MageResourceGenerator.from_data(mage._stats, mage.data))
	processor.add_process_handler(MageProcessHandler.new(mage._anim, mage._m_ability_system))
	
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
	ability_system: MCharacterAbilitySystem,
) -> void:
	processor.add_input_handler(MageInputHandler.new(ability_system, kinematics))

static func _create_movement_context(mage: MageCharacter) -> MageMovementContext:
	var movement_config := MageMovementConfig.from_mage(mage)
	var movement_motion := MageMovementMotion.from_mage(mage)
	
	return MageMovementContext.new(mage, movement_config, movement_motion)
