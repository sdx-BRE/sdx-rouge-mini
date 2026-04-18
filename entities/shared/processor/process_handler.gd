class_name ProcessHandler extends RefCounted

func process(delta: float) -> void:
	push_error("[Error][ProcessHandler]: process() must be overwritten by child implementations, delta: ", delta)
