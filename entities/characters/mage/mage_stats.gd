class_name MageStats extends RefCounted

signal health_changed(current: float, total: float)
signal mana_changed(current: float, total: float)
signal stamina_changed(current: float, total: float)

signal health_reached_zero()
signal mana_reached_zero()
signal stamina_reached_zero()

var _max_health: float
var _max_mana: float
var _max_stamina: float

var _health: float
var _mana: float
var _stamina: float

func _init(
	max_health: float,
	max_mana: float,
	max_stamina: float,
	health: float,
	mana: float,
	stamina: float,
) -> void:
	_max_health = max_health
	_max_mana = max_mana
	_max_stamina = max_stamina
	_health = health
	_mana = mana
	_stamina = stamina

static func from_data(data: MageData) -> MageStats:
	return MageStats.new(data.health, data.mana, data.stamina, data.health, data.mana, data.stamina)

func take_dmg(value: float) -> void:
	if _health <= 0: return
	_apply_health_modifier(-absf(value))

func heal(value: float) -> void:
	if _health <= 0: return
	_apply_health_modifier(absf(value))

func use_mana(value: float) -> void:
	if _mana <= 0: return
	_apply_mana_modifier(-absf(value))

func restore_mana(value: float) -> void:
	if _mana <= 0: return
	_apply_mana_modifier(absf(value))

func has_mana(value: float) -> bool:
	return _mana >= value

func use_stamina(value: float) -> void:
	if _stamina <= 0: return
	_apply_stamina_modifier(-absf(value))

func restore_stamina(value: float) -> void:
	if _stamina <= 0: return
	_apply_stamina_modifier(absf(value))

func has_stamina(value: float) -> bool:
	return _stamina >= value

func _apply_health_modifier(delta: float) -> void:
	var old := _health
	_health = clamp(_health + delta, 0, _max_health)
	
	if old != _health:
		health_changed.emit(_health, _max_health)
		
		if _health <= 0:
			health_reached_zero.emit()

func _apply_mana_modifier(delta: float) -> void:
	var old := _mana
	_mana = clamp(_mana + delta, 0, _max_mana)
	
	if old != _mana:
		mana_changed.emit(_mana, _max_mana)
		
		if _mana <= 0:
			mana_reached_zero.emit()

func _apply_stamina_modifier(delta: float) -> void:
	var old := _stamina
	_stamina = clamp(_stamina + delta, 0, _max_stamina)
	
	if old != _stamina:
		stamina_changed.emit(_stamina, _max_stamina)
		
		if _stamina <= 0:
			stamina_reached_zero.emit()
