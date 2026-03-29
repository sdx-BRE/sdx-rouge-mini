class_name MageBootstrapper extends RefCounted

static func bootstrap(
	mage: MageCharacter,
	signals: MageSignals,
) -> void:
	var movement_context := _create_movement_context(mage)
	
	MageBootstrapper._bootstrap_stats(mage, signals)
	MageBootstrapper._bootstrap_anim(mage, signals)
	MageBootstrapper._bootstrap_abilities(mage, movement_context)
	MageBootstrapper._bootstrap_processor(mage, movement_context)

static func _bootstrap_stats(mage: MageCharacter, signals: MageSignals) -> void:
	mage._stats = MageStats.from_data(mage.data)
	
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
	)
	mage._anim.register_signals(signals.died)

static func _bootstrap_abilities(mage: MageCharacter, movement_context: MageMovementContext) -> void:
	var controller := MageController.new(movement_context)
	
	mage._abilities = MageAbilityHandler.create(
		mage, 
		mage._anim, 
		mage._stats, 
		controller, 
		mage.casting_started, 
		mage.casting_progressed, 
		mage.casting_end
	)

static func _bootstrap_processor(mage: MageCharacter, movement_context: MageMovementContext) -> void:
	var kinematics := MageKinematics.new(movement_context)
	var motor := MageMotor.new(movement_context)
	
	var sensors := MageSensors.new(movement_context)
	var resource_generator := MageResourceGenerator.from_data(mage._stats, mage.data)
	var airbourne_observer := ObserverAirbourne.new(mage)
	
	airbourne_observer.subscribe_ground(MageOnGroundSubscriber.new(mage._anim, movement_context, mage.animation_jump_land.anim_trigger))
	
	mage._processor = MageProcessorAssembler.assemble(
		kinematics, 
		motor, 
		sensors, 
		mage._anim, 
		mage._abilities, 
		resource_generator, 
		airbourne_observer, 
		mage.get_viewport(),
	)

static func _create_movement_context(mage: MageCharacter) -> MageMovementContext:
	var movement_config := MageMovementConfig.from_mage(mage)
	var movement_motion := MageMovementMotion.from_mage(mage)
	
	return MageMovementContext.new(mage, movement_config, movement_motion)
