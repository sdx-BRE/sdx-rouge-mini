class_name AggroChaseTarget extends RefCounted

var _ctx: StateContext
var _last_enemy_pos: Vector3 = Vector3.ZERO

func _init(ctx: StateContext) -> void:
	_ctx = ctx

func process(delta: float) -> void:
	var target_pos := _ctx.get_target_position()
	if _last_enemy_pos != target_pos:
		_last_enemy_pos = target_pos
		_ctx.change_target(target_pos)
	
	_ctx.run_to_target(delta)
