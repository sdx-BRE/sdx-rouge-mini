class_name SkeletonMinionStateMachine extends RefCounted

var _machine: EnemyStateMachine

func _init(machine: EnemyStateMachine) -> void:
	_machine = machine

static func create(
	target_handler: AiTargetHandler,
	controller: EnemyController,
	data: EnemyData,
	stats: EnemyStats,
	anim: SkeletonMinionAnimator,
) -> SkeletonMinionStateMachine:
	var aggro_rule := StateTransitionRule.new(
		StateTransition.AGGRO,
		func() -> bool: return target_handler.update_and_has_target()
	)
	
	var attack_context := SkeletonMinionMeleeAttack.new(anim)
	var context := StateContext.new(target_handler, controller, data, stats, attack_context)
	
	
	var waiting_state := WaitingState.new(context)
	var walking_state := WalkingState.new(context)
	
	var attack_target := AggroAttackTarget.new(context)
	var chase_target := AggroChaseTarget.new(context)
	var aggro_state := AggroState.new(context, attack_target, chase_target)
	
	var states: Dictionary[int, StateBase] = {}
	states.set(StateTransition.AGGRO, aggro_state)
	states.set(StateTransition.WALKING, walking_state)
	states.set(StateTransition.WAITING, waiting_state)
	states.set(StateTransition.TARGET_LOST, waiting_state)
	
	var machine := EnemyStateMachine.new(walking_state, states, [aggro_rule])
	
	return SkeletonMinionStateMachine.new(machine)

func process(delta: float) -> void:
	_machine.process(delta)
