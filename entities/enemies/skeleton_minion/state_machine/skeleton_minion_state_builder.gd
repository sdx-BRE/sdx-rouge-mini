class_name SkeletonMinionStateBuilder extends RefCounted

var _context: SkeletonMinionStateContext
var _stats: EnemyStats

var _alive_state: SkeletonMinionStateAlive
var _dead_state: SkeletonMinionStateDead

func _init(context: SkeletonMinionStateContext, stats: EnemyStats) -> void:
	_context = context
	_stats = stats

func with_alive_behavior(
	start: SkeletonMinionStateMachine.ChangeId = SkeletonMinionStateMachine.ChangeId.Walking,
) -> SkeletonMinionStateBuilder:
	var walking_state := SkeletonMinionStateAliveWalking.new(_context)
	var waiting_state := SkeletonMinionStateAliveWaiting.new(_context)
	
	var attacking_state := SkeletonMinionStateAliveAggroAttacking.new(_context)
	var chasing_state := SkeletonMinionStateAliveAggroChasing.new(_context)
	var aggro_state := SkeletonMinionStateAliveAggro.new(_context, attacking_state, chasing_state)
	
	var start_alive_state: SkeletonMinionStateBase = walking_state
	match start:
		SkeletonMinionStateMachine.ChangeId.Waiting: start_alive_state = waiting_state
		SkeletonMinionStateMachine.ChangeId.Aggro: start_alive_state = aggro_state
		SkeletonMinionStateMachine.ChangeId.None: start_alive_state = walking_state
		SkeletonMinionStateMachine.ChangeId.Walking: start_alive_state = walking_state
	
	_alive_state = SkeletonMinionStateAlive.new(start_alive_state, _context)
	
	_alive_state.add_state(SkeletonMinionStateMachine.ChangeId.Walking, walking_state)
	_alive_state.add_state(SkeletonMinionStateMachine.ChangeId.Waiting, waiting_state)
	_alive_state.add_state(SkeletonMinionStateMachine.ChangeId.Aggro, aggro_state)
	
	return self

func with_dead_behavior() -> SkeletonMinionStateBuilder:
	_dead_state = SkeletonMinionStateDead.new(_context)
	
	return self

func build() -> SkeletonMinionStateMachine:
	var alive_handler := SkeletonMinionStateMachineStateHandlerAlive.new(_alive_state)
	var dead_handler := SkeletonMinionStateMachineStateHandlerDead.new(_dead_state, alive_handler, _stats)
	var root_handler := SkeletonMinionStateMachineStateHandler.new(dead_handler)
	
	return SkeletonMinionStateMachine.new(root_handler, _context._target_handler, _context._data)
