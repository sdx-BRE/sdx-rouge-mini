class_name SkeletonMinionStateAliveAggro extends SkeletonMinionStateBase

var _attacking: SkeletonMinionStateAliveAggroAttacking
var _chasing: SkeletonMinionStateAliveAggroChasing

func _init(
	controller: SkeletonMinionController,
	target_handler: SkeletonMinionStateMachineTargetHandler,
	anim: SkeletonMinionAnimator,
	data: SkeletonMinionStateData,
	config: SkeletonMinionStateConfig,
	attacking: SkeletonMinionStateAliveAggroAttacking,
	chasing: SkeletonMinionStateAliveAggroChasing,
) -> void:
	super(controller, target_handler, anim, data, config)
	_attacking = attacking
	_chasing = chasing

func process(delta: float) -> SkeletonMinionStateMachine.ChangeId:
	if not _target_handler.has_target():
		# Todo: Implement pushdown automata support to return to previous state
		return SkeletonMinionStateMachine.ChangeId.Waiting
	
	if _target_handler.is_target_in_range(): _attacking.process(delta)
	else: _chasing.process(delta)
	
	return SkeletonMinionStateMachine.ChangeId.None
