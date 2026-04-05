class_name MageSignals extends RefCounted

var died: Signal
var dying: Signal
var health_changed: Signal
var mana_changed: Signal
var stamina_changed: Signal
var casting_started: Signal
var casting_end: Signal
var casting_progressed: Signal
var skill_cooldown: Signal

func _init(
	s_died: Signal,
	s_dying: Signal,
	s_health_changed: Signal,
	s_mana_changed: Signal,
	s_stamina_changed: Signal,
	s_casting_started: Signal,
	s_casting_end: Signal,
	s_casting_progressed: Signal,
	s_skill_cooldown: Signal,
) -> void:
	died = s_died
	dying = s_dying
	health_changed = s_health_changed
	mana_changed = s_mana_changed
	stamina_changed = s_stamina_changed
	casting_started = s_casting_started
	casting_end = s_casting_end
	casting_progressed = s_casting_progressed
	skill_cooldown = s_skill_cooldown
