class_name SkeletonMinionStateAliveAggroChasing extends SkeletonMinionStateBase

var _last_enemy_pos: Vector3 = Vector3.ZERO

func process(delta: float):
	var target_pos := _target_handler.get_target_position()
	if _last_enemy_pos != target_pos:
		_last_enemy_pos = target_pos
		_controller.change_target(target_pos)
	
	_controller.navigate_to_target(_data.running_speed, delta)
