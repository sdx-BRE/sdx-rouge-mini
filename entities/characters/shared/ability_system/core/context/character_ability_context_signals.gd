class_name CharacterAbilityContextSignals extends RefCounted

var ability_started: Signal
var ability_end: Signal
var ability_progressed: Signal

func _init(
	p_ability_started: Signal,
	p_ability_progressed: Signal,
	p_ability_end: Signal,
) -> void:
	ability_started = p_ability_started
	ability_progressed = p_ability_progressed
	ability_end = p_ability_end
