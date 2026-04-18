class_name StateContextAttack extends RefCounted

func try_attack(context: StateContext) -> void:
	push_error("[Error][StateContextAttack]: try_attack() must be overwritten by child , context: ", context)
