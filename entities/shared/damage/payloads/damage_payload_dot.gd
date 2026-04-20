class_name DamagePayloadDot extends DamagePayload

var duration: float
var tick_interval: float
var tick_damage: float

func _init(_duration: float, _tick_interval: float, _tick_damage: float) -> void:
	duration = _duration
	tick_interval = _tick_interval
	tick_damage = _tick_damage

func get_debuff(stats: EntityStats) -> EntityDebuff:
	return EntityDebuffDot.new(stats, self)
