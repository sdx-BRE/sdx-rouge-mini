class_name SkeletonIceMageBootstrapper extends RefCounted

static func bootstrap(entity: SkeletonIceMage) -> void:
	_bootstrap_props(entity)
	_bootstrap_processor(entity)
	_wire_signals(entity)

static func _bootstrap_props(entity: SkeletonIceMage) -> void:
	var fov_threshold := cos(deg_to_rad(entity.fov_angle / 2.0))
	
	entity._stats = EntityStats.from_data(entity.data)
	entity._target_handler = AiTargetHandler.new(entity, entity.ATTACK_RANGE, fov_threshold)
	
	var anim_params := SkeletonIceMageAnimationParams.from_entity((entity))
	var animator := EnemyAnimator.new(entity.anim_tree)
	
	animator.add_playback_from_param(EnemyAnimator.StatePlayback.FullBody, entity.path_playback_full_body)
	entity._anim = SkeletonIceMageAnimator.new(animator, anim_params)

static func _bootstrap_processor(entity: SkeletonIceMage) -> void:
	# Todo: Replace hard coded config
	var config := EnemyMovementConfig.new()
	
	var motion := EnemyMovementMotion.create()
	var context := EnemyMovementContext.new(entity, entity.agent, config, motion)
	var kinematics := EnemyKinematics.new(context)
	
	var state_machine := create_state_machine(entity, context)
	entity._processor = EntityProcessor.new(entity.get_viewport())
	entity._processor.add_process_handler(EnemyStateMachineHandler.new(state_machine))
	
	entity._processor.add_physics_handler(EnemyVelocityHandler.new(kinematics))
	entity._processor.add_physics_handler(SkeletonIceMageLocomotionHandler.new(
		kinematics,
		entity._anim, 
		entity.data.walking_speed, 
		entity.data.running_speed,
	))
	entity._processor.add_physics_handler(EnemyCollisionsHandler.new(kinematics))

static func create_state_machine(
	entity: SkeletonIceMage,
	movement_context: EnemyMovementContext,
) -> EnemyStateMachine:
	var aggro_rule := StateTransitionRule.new(
		StateTransition.AGGRO,
		func() -> bool: return entity._target_handler.update_and_has_target()
	)
	
	var controller := EnemyController.new(movement_context, entity.patrol_points)
	var blackboard := EnemyBlackboard.from_data(entity.data)
	var attack_context := SkeletonIceMageAttack.new()
	var context := StateContext.new(entity._target_handler, controller, blackboard, entity.data, entity._stats, attack_context)
	
	var waiting_state := WaitingState.new(context)
	var walking_state := WalkingState.new(context)
	var aggro_state := AggroState.new(context)
	
	var states: Dictionary[int, StateBase] = {}
	states.set(StateTransition.AGGRO, aggro_state)
	states.set(StateTransition.WALKING, walking_state)
	states.set(StateTransition.WAITING, waiting_state)
	
	return EnemyStateMachine.new(walking_state, states, context, [aggro_rule])

static func _wire_signals(entity: SkeletonIceMage) -> void:
	if entity.ui is EnemyUI:
		entity._stats.health_changed.connect(entity.ui.update_health)
	entity._stats.hp_reached_zero.connect(entity.on_die)
	
	entity.fov.area_entered.connect(entity._on_fov_entered)
	entity.fov.area_exited.connect(entity._on_fov_exited)
