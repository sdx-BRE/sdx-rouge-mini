class_name SkeletonMinionStateBase extends RefCounted

var _context: SkeletonMinionStateContext

func _init(
	context: SkeletonMinionStateContext,
) -> void:
	_context = context

func process(delta: float) -> SkeletonMinionStateMachine.ChangeId:
	push_error("[Error][SkeletonMinionStateBase]: process() must be overwritten by child implementations")
	return SkeletonMinionStateMachine.ChangeId

func enter() -> void: pass
