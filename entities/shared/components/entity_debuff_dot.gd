class_name EntityDebuffDot extends EntityDebuff

var tick_damage: float = 0.0

func _init(stats: EntityStats, payload: DamagePayloadDot) -> void:
	super(stats, payload.duration, payload.tick_interval)
	tick_damage = payload.tick_damage

func _on_tick() -> void:
	super()
	_stats.take_damage(tick_damage)
