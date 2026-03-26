class_name SkeletonMinionStateAliveAggroAttacking extends SkeletonMinionStateBase

func process(_delta: float):
	_controller.apply_friction_if_moving(_data.walking_speed)
	
	if not _anim.is_attacking and _data.attack_cooldown <= 0:
		_anim.punch_attack()
		_data.attack_cooldown = _config.attack_cooldown
