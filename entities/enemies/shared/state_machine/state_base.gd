class_name StateBase extends RefCounted

var _ctx: StateContext

func _init(ctx: StateContext) -> void:
	_ctx = ctx

func process(delta: float) -> int:
	push_error("[Error][StateMachineBaseState]: process(delta: float) must be overwritten by child implementations, delta: ", delta)
	return StateTransition.NONE

func enter() -> void: pass
func exit() -> void: pass
