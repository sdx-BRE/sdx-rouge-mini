class_name DeadState extends StateMachineSuperState

func process(_delta: float) -> void:
	if _ctx.is_moving():
		_ctx.stop_instant()

func can_handle() -> bool:
	return _ctx.is_dead()
