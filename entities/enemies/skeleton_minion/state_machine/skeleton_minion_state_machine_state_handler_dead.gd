class_name SkeletonMinionStateMachineStateHandlerDead extends SkeletonMinionStateMachineStateHandlerBase

var _dead_state: SkeletonMinionStateDead
var _alive_handler: SkeletonMinionStateMachineStateHandlerAlive
var _host_stats: EnemyStats

func _init(
	dead_state: SkeletonMinionStateDead,
	alive_handler: SkeletonMinionStateMachineStateHandlerAlive,
	host_stats: EnemyStats,
) -> void:
	_dead_state = dead_state
	_alive_handler = alive_handler
	_host_stats = host_stats

func handle(delta: float) -> void:
	if _host_stats.is_alive():
		_alive_handler.handle(delta)
		return
	
	_dead_state.process(delta)
