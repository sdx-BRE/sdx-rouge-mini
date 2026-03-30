class_name AliveState extends StateMachineSuperState

func process(delta: float) -> void:
	pass

func can_handle() -> bool:
	return _ctx.is_alive()
