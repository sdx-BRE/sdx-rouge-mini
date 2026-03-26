class_name SkeletonMinionStateAliveAggro extends SkeletonMinionStateBase

var _attacking: SkeletonMinionStateAliveAggroAttacking
var _chasing: SkeletonMinionStateAliveAggroChasing

func _init(
	context: SkeletonMinionStateContext,
	attacking: SkeletonMinionStateAliveAggroAttacking,
	chasing: SkeletonMinionStateAliveAggroChasing,
) -> void:
	super(context)
	_attacking = attacking
	_chasing = chasing

func process(delta: float) -> SkeletonMinionStateMachine.ChangeId:
	if not _context.has_target():
		# Todo: Implement pushdown automata support to return to previous state
		return SkeletonMinionStateMachine.ChangeId.Waiting
	
	if _context.is_target_in_range(): _attacking.process(delta)
	else: _chasing.process(delta)
	
	return SkeletonMinionStateMachine.ChangeId.None
