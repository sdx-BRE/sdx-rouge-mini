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

static func start_walking(context: SkeletonMinionStateContext, stats: EnemyStats) -> SkeletonMinionStateMachine:
	var builder := SkeletonMinionStateBuilder.new(context, stats)
	
	return builder \
		.with_alive_behavior() \
		.with_dead_behavior() \
		.build()

enum ChangeId {
	None,
	Waiting,
	Walking,
	Aggro,
}
