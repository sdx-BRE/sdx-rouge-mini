class_name EntityDebuffs extends RefCounted

var _active_debuffs: Array[EntityDebuff] = []

func add_debuff(debuff: EntityDebuff) -> void:
	_active_debuffs.append(debuff)
	debuff._on_start()

func tick(delta: float) -> void:
	for debuff in _active_debuffs:
		debuff.tick(delta)
	
	_active_debuffs = _active_debuffs.filter(func(d): return not d.is_expired)
