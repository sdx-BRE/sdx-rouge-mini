class_name SkeletonMinionStateMachineAssembler extends RefCounted

static func assemble(
	target_handler: AiTargetHandler,
	controller: EnemyController,
	blackboard: EnemyBlackboard,
	data: EnemyData,
	stats: EnemyStats,
	anim: SkeletonMinionAnimator,
) -> EnemyStateMachine:
	var aggro_rule := StateTransitionRule.new(
		StateTransition.AGGRO,
		func() -> bool: return target_handler.update_and_has_target()
	)
	
	var attack_context := SkeletonMinionMeleeAttack.new(anim)
	var context := StateContext.new(target_handler, controller, blackboard, data, stats, attack_context)
	
	var waiting_state := WaitingState.new(context)
	var walking_state := WalkingState.new(context)
	var aggro_state := AggroState.new(context)
	
	var states: Dictionary[int, StateBase] = {}
	states.set(StateTransition.AGGRO, aggro_state)
	states.set(StateTransition.WALKING, walking_state)
	states.set(StateTransition.WAITING, waiting_state)
	
	return EnemyStateMachine.new(walking_state, states, context, [aggro_rule])
