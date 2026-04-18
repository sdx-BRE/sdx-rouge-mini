class_name WalkingState extends StateBase

func process(_delta: float) -> int:
	if _ctx.is_navigation_finished():
		return StateTransition.WAITING
	
	_ctx.walk_to_target()
	return StateTransition.NONE

func enter() -> void:
	pass
