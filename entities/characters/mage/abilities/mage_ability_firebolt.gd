class_name MageAbilityFirebolt extends MageAbilitySpell.Instant

func execute() -> void:
	_context.notify_casting_end()
	_init_at_wand_spawnpoint(_anim.scene)

func start() -> MageAbilityPhased.StartResult:
	_context.request_oneshot_animation(_anim.oneshot_prop)
	_context.notify_casting_started()
	
	return MageAbilityPhased.StartResult.Cast
