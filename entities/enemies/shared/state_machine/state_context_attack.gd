class_name StateContextAttack extends RefCounted

signal attacked()

func try_attack(context: StateContext) -> void:
	push_error("[Error][StateContextAttack]: try_attack() must be overwritten by child , context: ", context)

func _emit_attacked() -> void:
	attacked.emit()
