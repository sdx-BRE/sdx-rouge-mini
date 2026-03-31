class_name AggroState extends StateBase

var _last_enemy_pos: Vector3 = Vector3.ZERO

func process(delta: float) -> int:
	if not _ctx.has_target():
		return StateTransition.POP
	
	if _ctx.is_target_in_range(): _attack_target()
	else: _chase_target(delta)
	
	return StateTransition.NONE

func _chase_target(delta: float) -> void:
	var target_pos := _ctx.get_target_position()
	if _last_enemy_pos != target_pos:
		_last_enemy_pos = target_pos
		_ctx.change_target(target_pos)
	
	_ctx.run_to_target(delta)

func _attack_target() -> void:
	_ctx.stop_moving()
	_ctx.try_attack()
