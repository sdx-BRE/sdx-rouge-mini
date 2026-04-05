class_name MageBootstrapper extends RefCounted

static func bootstrap(
	mage: MageCharacter,
	signals: MageSignals,
) -> void:
	var movement_context := _create_movement_context(mage)
	var motor := MageMotor.new(movement_context)
	
	MageBootstrapper._bootstrap_stats(mage, signals)
	MageBootstrapper._bootstrap_anim(mage, signals)
	MageBootstrapper._bootstrap_abilities(mage, movement_context, motor)
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

static func _bootstrap_abilities(mage: MageCharacter, movement_context: MageMovementContext, motor: MageMotor) -> void:
	var registry := CharacterAbilityRegistry.new()
	var signals := CharacterAbilitySignals.new(mage.casting_started, mage.casting_progressed, mage.casting_end)
	
	var controller := MageController.new(movement_context)
	var instant_context := InstantContext.new(
		mage.pivot,
		controller,
		mage.anim_tree,
	)
	var phased_context := PhasedContext.create(
		mage,
		mage.pivot,
		mage.buff_anchor,
		mage.anim_tree,
		signals,
		mage.camera_node,
		mage.wandspawn_node,
		mage.ground_target_marker,
		mage.enemy_target_marker,
		mage.get_viewport(),
		mage.get_world_3d(),
	)
	var channeled_context := ChanneledContext.new(controller)
	var factory := CharacterAbilityFactory.new(mage._stats, phased_context, instant_context, channeled_context)
	
	for ability_data in mage.abilities:
		registry.add(ability_data.id, factory.create_ability(ability_data))
	
	var cooldown_manager := CooldownManager.new()
	
	var channeled_handler := ChanneledAbilityHandler.new(cooldown_manager)
	var instant_handler := InstantAbilityHandler.new(cooldown_manager)
	var phased_handler := PhasedAbilityHandler.new(cooldown_manager)
	
	var manager := CharacterAbilityManager.new(channeled_handler, instant_handler, phased_handler)
	
	mage._ability_system = CharacterAbilitySystem.new(registry, manager)
	
	motor.jumped.connect(func(): mage._ability_system.on_ability_triggered(CharacterAbilityId.JUMP))
	motor.add_jump_gate(func() -> bool: return mage._ability_system.has_resources(CharacterAbilityId.JUMP))

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
	processor.add_process_handler(MageResourceGenerator.from_data(mage._stats, mage.data))
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
	ability_system: CharacterAbilitySystem,
) -> void:
	processor.add_input_handler(MageInputHandler.new(ability_system, kinematics))

static func _create_movement_context(mage: MageCharacter) -> MageMovementContext:
	var movement_config := MageMovementConfig.from_mage(mage)
	var movement_motion := MageMovementMotion.from_mage(mage)
	
	return MageMovementContext.new(mage, movement_config, movement_motion)
