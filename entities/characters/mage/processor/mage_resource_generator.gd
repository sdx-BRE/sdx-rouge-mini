class_name MageResourceGenerator extends ProcessHandler

var _stats: EntityStats
var _mana_regen: float
var _stamina_regen: float

func _init(
	stats: EntityStats,
	mana_regen: float,
	stamina_regen: float,
) -> void:
	_stats = stats
	_mana_regen = mana_regen
	_stamina_regen = stamina_regen

static func from_data(stats: EntityStats, data: MageData) -> MageResourceGenerator:
	return MageResourceGenerator.new(stats, data.mana_regeneration, data.stamina_regeneration)

func process(delta: float) -> void:
	_stats.restore_mana(_mana_regen * delta)
	_stats.restore_stamina(_stamina_regen * delta)
