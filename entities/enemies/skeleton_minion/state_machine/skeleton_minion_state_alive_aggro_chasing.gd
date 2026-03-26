class_name SkeletonMinionStateAliveAggroChasing extends SkeletonMinionStateBase

var _last_enemy_pos: Vector3 = Vector3.ZERO

func process(delta: float):
	var target_pos := _context.get_target_position()
	if _last_enemy_pos != target_pos:
		_last_enemy_pos = target_pos
		_context.change_target(target_pos)
	
	_context.run_to_target(delta)
