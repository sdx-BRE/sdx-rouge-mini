class_name SkeletonMinionStateFactory extends RefCounted

var _controller: SkeletonMinionController
var _target_handler: SkeletonMinionStateMachineTargetHandler
var _anim: SkeletonMinionAnimator
var _data: SkeletonMinionStateData
var _config: SkeletonMinionStateConfig

func _init(
	controller: SkeletonMinionController,
	target_handler: SkeletonMinionStateMachineTargetHandler,
	anim: SkeletonMinionAnimator,
	data: SkeletonMinionStateData,
	config: SkeletonMinionStateConfig,
) -> void:
	_controller = controller
	_target_handler = target_handler
	_anim = anim
	_data = data
	_config = config

func create_state_machine(
	state_handler: SkeletonMinionStateMachineStateHandler,
) -> SkeletonMinionStateMachine:
	return SkeletonMinionStateMachine.new(state_handler, _target_handler, _data)

func create_walking() -> SkeletonMinionStateAliveWalking:
	return SkeletonMinionStateAliveWalking.new(_controller, _target_handler, _anim, _data, _config)

func create_waiting() -> SkeletonMinionStateAliveWaiting:
	return SkeletonMinionStateAliveWaiting.new(_controller, _target_handler, _anim, _data, _config)

func create_aggro(attacking: SkeletonMinionStateAliveAggroAttacking, chasing: SkeletonMinionStateAliveAggroChasing) -> SkeletonMinionStateAliveAggro:
	return SkeletonMinionStateAliveAggro.new(_controller, _target_handler, _anim, _data, _config, attacking, chasing)

func create_attacking() -> SkeletonMinionStateAliveAggroAttacking:
	return SkeletonMinionStateAliveAggroAttacking.new(_controller, _target_handler, _anim, _data, _config)

func create_chasing() -> SkeletonMinionStateAliveAggroChasing:
	return SkeletonMinionStateAliveAggroChasing.new(_controller, _target_handler, _anim, _data, _config)

func create_alive_state(starting_state: SkeletonMinionStateBase) -> SkeletonMinionStateAlive:
	return SkeletonMinionStateAlive.new(starting_state, _target_handler, _data)

func create_alive_handler(alive_state: SkeletonMinionStateAlive) -> SkeletonMinionStateMachineStateHandlerAlive:
	return SkeletonMinionStateMachineStateHandlerAlive.new(alive_state)

func create_dead_state() -> SkeletonMinionStateDead:
	return SkeletonMinionStateDead.new(_controller, _target_handler, _anim, _data, _config)

func create_dead_handler(
	dead_state: SkeletonMinionStateDead,
	alive_handler: SkeletonMinionStateMachineStateHandlerAlive,
	host_stats: EnemyStats,
) -> SkeletonMinionStateMachineStateHandlerDead:
	return SkeletonMinionStateMachineStateHandlerDead.new(dead_state, alive_handler, host_stats)

func create_state_handler(handler: SkeletonMinionStateMachineStateHandlerBase) -> SkeletonMinionStateMachineStateHandler:
	return SkeletonMinionStateMachineStateHandler.new(handler)
