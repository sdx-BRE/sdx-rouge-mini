class_name SkeletonMinionStateMachine extends RefCounted

const ATTACK_RANGE := 1.53

var _state_handler: SkeletonMinionStateMachineStateHandler
var _target_handler: SkeletonMinionStateMachineTargetHandler
var _data: SkeletonMinionStateData

func _init(
	state_handler: SkeletonMinionStateMachineStateHandler,
	target_handler: SkeletonMinionStateMachineTargetHandler,
	data: SkeletonMinionStateData,
) -> void:
	_state_handler = state_handler
	_target_handler = target_handler
	_data = data

func process(delta: float) -> void:
	_state_handler.handle(delta)

func target_entered(target: Node3D) -> void:
	_target_handler.add_target(target)

func target_exited(target: Node3D) -> void:
	_target_handler.remove_target(target)

static func start_walking_bak(
	host: CharacterBody3D,
	controller: SkeletonMinionController,
	stats: EnemyStats,
	anim: SkeletonMinionAnimator,
	data: SkeletonMinionStateData,
	config: SkeletonMinionStateConfig,
) -> SkeletonMinionStateMachine:
	controller.use_first_patrol_point()
	var target_handler := SkeletonMinionStateMachineTargetHandler.new(host)
	
	var walking_state := SkeletonMinionStateAliveWalking.new(controller, target_handler, anim, data, config)
	var waiting_state := SkeletonMinionStateAliveWaiting.new(controller, target_handler, anim, data, config)
	
	var alive_state := SkeletonMinionStateAlive.new(walking_state, target_handler, data)
	alive_state.add_state(ChangeId.Walking, walking_state)
	alive_state.add_state(ChangeId.Waiting, waiting_state)
	
	var alive_handler := SkeletonMinionStateMachineStateHandlerAlive.new(alive_state)
	
	var dead_state := SkeletonMinionStateDead.new(controller, target_handler, anim, data, config)
	var dead_handler := SkeletonMinionStateMachineStateHandlerDead.new(dead_state, alive_handler, stats)
	
	var state_handler := SkeletonMinionStateMachineStateHandler.new(dead_handler)
	return SkeletonMinionStateMachine.new(state_handler, target_handler, data)

static func start_walking(factory: SkeletonMinionStateFactory, stats: EnemyStats) -> SkeletonMinionStateMachine:
	var walking_state := factory.create_walking()
	var waiting_state := factory.create_waiting()
	
	var attacking_state := factory.create_attacking()
	var chasing_state := factory.create_chasing()
	var aggro_state := factory.create_aggro(attacking_state, chasing_state)
	
	var alive_state := factory.create_alive_state(walking_state)
	alive_state.add_state(ChangeId.Walking, walking_state)
	alive_state.add_state(ChangeId.Waiting, waiting_state)
	alive_state.add_state(ChangeId.Aggro, aggro_state)
	
	var alive_handler := factory.create_alive_handler(alive_state)
	
	var dead_state := factory.create_dead_state()
	var dead_handler := factory.create_dead_handler(dead_state, alive_handler, stats)
	
	var state_handler := factory.create_state_handler(dead_handler)
	
	return factory.create_state_machine(state_handler)

enum ChangeId {
	None,
	Waiting,
	Walking,
	Aggro,
}
