class_name SkeletonMinionBootstrapper extends RefCounted

static func bootstrap(minion: SkeletonMinion) -> void:
	_bootstrap_props(minion)
	_bootstrap_processor(minion)
	_wire_signals(minion)

static func _bootstrap_props(minion: SkeletonMinion) -> void:
	var fov_threshold := cos(deg_to_rad(minion.fov_angle / 2.0))
	
	minion._stats = EnemyStats.from_data(minion.data)
	minion._target_handler = AiTargetHandler.new(minion, minion.ATTACK_RANGE, fov_threshold)
	
	var anim_params := SkeletonMinionAnimationParams.from_minion(minion)
	var animator := EnemyAnimator.new(minion.anim_tree)
	
	animator.add_playback_from_param(EnemyAnimator.StatePlayback.FullBody, minion.path_playback_full_body)
	minion._anim = SkeletonMinionAnimator.new(animator, anim_params)

static func _bootstrap_processor(minion: SkeletonMinion) -> void:
	# Todo: Replace hard coded config
	var config := EnemyMovementConfig.new()
	
	var motion := EnemyMovementMotion.create()
	var context := EnemyMovementContext.new(minion, minion.agent, config, motion)
	var controller := EnemyController.new(context, minion.patrol_points)
	var kinematics := EnemyKinematics.new(context)
	
	var state_machine := SkeletonMinionStateMachineAssembler.assemble(
		minion._target_handler,
		controller,
		EnemyBlackboard.from_data(minion.data),
		minion.data,
		minion._stats,
		minion._anim,
	)
	minion._processor = EntityProcessor.new(minion.get_viewport())
	minion._processor.add_process_handler(EnemyStateMachineHandler.new(state_machine))
	
	minion._processor.add_physics_handler(EnemyVelocityHandler.new(kinematics))
	minion._processor.add_physics_handler(SkeletonMinionLocomotionHandler.new(
		kinematics,
		minion._anim, 
		minion.data.walking_speed, 
		minion.data.running_speed,
	))
	minion._processor.add_physics_handler(EnemyCollisionsHandler.new(kinematics))

static func _wire_signals(minion: SkeletonMinion) -> void:
	if minion.ui is EnemyUI:
		minion._stats.health_changed.connect(minion.ui.update_health)
	minion._stats.hp_reached_zero.connect(minion.on_die)
	
	minion.fov.area_entered.connect(minion._on_fov_entered)
	minion.fov.area_exited.connect(minion._on_fov_exited)
	
	minion.punch_hitbox.body_entered.connect(minion._on_punch)
