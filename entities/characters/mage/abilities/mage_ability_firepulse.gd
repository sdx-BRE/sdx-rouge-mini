class_name MageAbilityFirepulse extends MageAbilitySpell.Instant

func execute() -> void:
	_context.notify_casting_end()
	var node := _init_at_wand_spawnpoint(_anim.scene)
	node.scale = Vector3(3, 3, 3)
	
	var distance := 1.75
	var forward := _context.get_forward()
	
	node.global_position += forward * distance

func start() -> MageAbilityPhased.StartResult:
	_context.request_oneshot_animation(_anim.oneshot_prop)
	_context.notify_casting_started()
	
	return MageAbilityPhased.StartResult.Cast
