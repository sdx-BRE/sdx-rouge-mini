class_name PhysicsProcessHandler extends RefCounted

func physics_process(delta: float) -> void:
	push_error("[Error][PhysicsProcessHandler]: physics_process() must be overwritten by child implementations, delta: ", delta)
