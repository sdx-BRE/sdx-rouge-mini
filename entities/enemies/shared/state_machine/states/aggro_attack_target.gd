class_name AggroAttackTarget extends RefCounted

var _ctx: StateContext

func _init(ctx: StateContext) -> void:
	_ctx = ctx

func process(_delta: float):
	_ctx.stop_moving()
	_ctx.try_attack()
