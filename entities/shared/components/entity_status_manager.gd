class_name EntityStatusManager extends RefCounted

signal health_changed(current: float, total: float, delta: float)
signal mana_changed(current: float, total: float, delta: float)
signal stamina_changed(current: float, total: float, delta: float)
signal health_reached_zero()
signal mana_reached_zero()
signal stamina_reached_zero()

var _stats: EntityStats
var _debuffs: EntityDebuffs
var _anchor: Node3D

func _init(stats: EntityStats, debuffs: EntityDebuffs, anchor: Node3D) -> void:
	_stats = stats
	_debuffs = debuffs
	_anchor = anchor
	
	_stats.health_changed.connect(_on_health_changed)
	_stats.mana_changed.connect(mana_changed.emit)
	_stats.stamina_changed.connect(stamina_changed.emit)
	
	_stats.health_reached_zero.connect(health_reached_zero.emit)
	_stats.mana_reached_zero.connect(mana_reached_zero.emit)
	_stats.stamina_reached_zero.connect(stamina_reached_zero.emit)

func _on_health_changed(current: float, total: float, delta: float) -> void:
	DamageGateway.emit_display_damage(absf(delta), _anchor.global_position)
	health_changed.emit(current, total, delta)

func is_alive() -> bool:
	return _stats.is_alive()

func take_damage(hit: DamageInstance) -> float:
	if not is_alive():
		return 0.0
	
	var damage := 0.0
	for payload in hit.payloads:
		damage += payload.get_immediate_damage()
		
		var debuff := payload.get_debuff(_stats)
		if debuff != null:
			_debuffs.add_debuff(debuff)
	
	_stats.take_damage(damage)
	return damage

func get_stats() -> EntityStats:
	return _stats

func process(delta: float) -> void:
	_debuffs.process(delta)
